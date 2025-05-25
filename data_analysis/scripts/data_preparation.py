import os
import shutil
import time
import pandas as pd

import scripts.database_operations as db


def execute_with_confirmation(description, function_to_execute, *args, **kwargs):
    print("\n" + description)
    confirmation = input("Press 1 to execute it: ")
    if confirmation == "1":
        return function_to_execute(*args, **kwargs)
    return None


def safe_read_csv(file_path):
    if os.path.getsize(file_path) == 0:
        return f"Skipped empty file: {file_path}"
    try:
        df = pd.read_csv(file_path, header=None)
        # Some files from StrokeEvent are incomplete and have "-" as cell values
        df = df.replace({"-": None})
        # Replaces nan to None to be compatible with Oracle database (nan is not recognized but None is treated as NULL)
        df = df.replace({float("nan"): None})
        return df
    except pd.errors.EmptyDataError:
        return f"Skipped corrupt or empty file: {file_path}"


def delete_directories_by_name(root_directory, directory_name_to_delete):
    directories_deleted_count = 0

    for directory_path, directory_names, file_names in os.walk(root_directory):
        for directory_name in directory_names:
            if directory_name == directory_name_to_delete:
                directory_full_path = directory_path + "\\" + directory_name
                shutil.rmtree(directory_full_path)
                print(f"{directory_full_path} directory and its contents have been deleted.")
                directories_deleted_count += 1

    if directories_deleted_count == 0:
        print(f"There were no {directory_name_to_delete} directories. Nothing was deleted.")


def list_all_files_with_extension(root_directory, extension_name):
    number_of_files = 0
    for directory_path, directory_names, file_names in os.walk(root_directory):
        for file_name in file_names:
            if file_name.endswith(extension_name):
                number_of_files += 1
                print(file_name)

    print(f"Total number of files: {str(number_of_files)} with {str(extension_name)} extension.")


def list_file_occurrences(root_directory, file_names_to_list=None):
    file_occurrences = {}
    for directory_path, directory_names, file_names in os.walk(root_directory):
        for file_name in file_names:
            if file_name not in file_occurrences:
                file_occurrences[file_name] = 1
            else:
                file_occurrences[file_name] += 1

    if file_names_to_list is None or len(file_names_to_list) == 0:
        print(file_occurrences)
    else:
        for file_name in file_names_to_list:
            print(f"{file_name}: {file_occurrences[file_name]}")


def get_file_occurrences(root_directory, file_name_to_get):
    file_occurrences = 0
    for directory_path, directory_names, file_names in os.walk(root_directory):
        for file_name in file_names:
            if file_name == file_name_to_get:
                file_occurrences += 1
    return file_occurrences


# Inefficient for large datasets because it runs out of RAM memory (MemoryError)
# For large datasets use insert_into_database=True
def get_files_data(root_directory, file_name_to_get, return_type='tuples', chunksize=None):
    files_all_data = []
    number_of_files = 0

    start_time = time.time()

    for directory_path, directory_names, file_names in os.walk(root_directory):
        for file_name in file_names:
            if file_name == file_name_to_get:
                file_full_path = f"{directory_path}\\{file_name}"
                file_data = pd.read_csv(file_full_path, header=None, chunksize=chunksize)

                if return_type == 'dataframe':
                    files_all_data.extend(file_data.values.tolist())
                elif return_type == 'tuples':
                    files_all_data.extend(file_data.itertuples(index=False, name=None))
                else:
                    raise ValueError("return_type must be either 'dataframe' or 'tuples'.")

                number_of_files += 1
                print(f"{file_full_path} was merged as file number {number_of_files}.")

    end_time = time.time()
    print(f"{end_time - start_time} seconds elapsed to merge the {file_name_to_get} files.")

    if return_type == 'dataframe':
        return pd.DataFrame(files_all_data)
    return files_all_data


def insert_into_database(root_directory, files_name_to_insert, files_total_occurrences):
    file_number_start = int(input("Start file index to insert (min: 0): "))
    file_number_end = int(input(f"End file index to insert (max: {files_total_occurrences}): "))

    one_file_all_data = []
    files_processed_number = 0
    skipped_files = []

    with db.get_database_connection(database_password="oracle") as connection:
        with connection.cursor() as cursor:
            for directory_path, directory_names, file_names in os.walk(root_directory):
                for file_name in file_names:
                    if file_name == files_name_to_insert:
                        files_processed_number += 1
                        if file_number_start < files_processed_number <= file_number_end:
                            file_full_path = f"{directory_path}\\{file_name}"
                            file_data = safe_read_csv(file_full_path)

                            if isinstance(file_data, str):
                                skipped_files.append([files_processed_number, file_data])
                                continue

                            one_file_all_data.extend(file_data.itertuples(index=False, name=None))

                            table_name = file_name[:-4]

                            file_metadata = [files_total_occurrences, files_processed_number, file_full_path]

                            db.insert_into_table(cursor, table_name, one_file_all_data, file_metadata)

                            one_file_all_data = []

            connection.commit()

    for skipped_file in skipped_files:
        print(f"File number: {skipped_file[0]}, path: {skipped_file[1]}")


def dataframe_to_csv(dataframe, file_name):
    dataframe.to_csv(f"..\\data\\{file_name}")


def main():
    root_directory = "D:\\Programe\\Flutter\\DaniVest\\data_analysis\\data\\hmog_dataset\\public_dataset"
    print(f"!!!!!!!!!! {root_directory} is the root directory !!!!!!!!!!")

    directory_name_to_delete = "__MACOSX"
    execute_with_confirmation(f"=== Delete {directory_name_to_delete} directories function ===",
                              delete_directories_by_name, root_directory,
                              directory_name_to_delete=directory_name_to_delete)

    extension_name = ".csv"
    execute_with_confirmation(f"=== List all files with {extension_name} extension function ===",
                              list_all_files_with_extension, root_directory, extension_name=extension_name)

    relevant_files = ["Activity.csv", "Accelerometer.csv", "Gyroscope.csv", "Magnetometer.csv", "TouchEvent.csv",
                      "KeyPressEvent.csv", "OneFingerTouchEvent.csv", "PinchEvent.csv", "ScrollEvent.csv",
                      "StrokeEvent.csv",
                      ]
    execute_with_confirmation("=== List file occurrences ===",
                              list_file_occurrences, root_directory, file_names_to_list=relevant_files)

    file_headers = [["ID", "SubjectID", "Session_number", "Start_time", "End_time", "Relative_Start_time",
                     "Relative_End_time", "Gesture_scenario", "TaskID", "ContentID"],
                    ["Systime", "EventTime", "ActivityID", "X", "Y", "Z", "Phone_orientation"],
                    ["Systime", "EventTime", "ActivityID", "X", "Y", "Z", "Phone_orientation"],
                    ["Systime", "EventTime", "ActivityID", "X", "Y", "Z", "Phone_orientation"],
                    ["Systime", "EventTime", "ActivityID", "Pointer_count", "PointerID", "ActionID", "X", "Y",
                     "Pressure", "Contact_size", "Phone_orientation"],
                    ["Systime", "PressTime", "ActivityID", "PressType", "KeyID", "Phone_orientation"],
                    ["Systime", "PressTime", "ActivityID", "TapID", "Tap_type", "Action_type", "X", "Y", "Pressure",
                     "Contact_size", "Phone_orientation"],
                    ["Systime", "PressTime", "ActivityID", "EventType", "PinchID", "Time_delta", "Focus_X", "Focus_Y",
                     "Span", "Span_X", "Span_Y", "ScaleFactor", "Phone_orientation"],
                    ["Systime", "BeginTime", "CurrentTime", "ActivityID", "ScrollID", "Start_action_type", "Start_X",
                     "Start_Y", "Start_pressure", "Start_size", "Current_action_type", "Current_X", "Current_Y",
                     "Current_pressure", "Current_size", "Distance_X", "Distance_Y", "Phone_orientation"],
                    ["Systime", "Begin_time", "End_time", "ActivityID", "Start_action_type", "Start_X", "Start_Y",
                     "Start_pressure", "Start_size", "End_action_type", "End_X", "End_Y", "End_pressure", "End_size",
                     "Speed_X", "Speed_Y", "Phone_orientation"]
                    ]

    files_data_as_dataframe = None
    files_data_as_tuples_list = None

    if len(relevant_files) == len(file_headers):
        for i in range(len(relevant_files)):
            file_name_to_get = relevant_files[i]
            file_header = file_headers[i]
            files_data_as_dataframe = execute_with_confirmation(
                f"=== Get all files data with the {file_name_to_get} name with the {file_header} headers in a dataframe function ===",
                get_files_data, root_directory, file_name_to_get=file_name_to_get, return_type="dataframe")

            if files_data_as_dataframe is not None:
                files_data_as_dataframe.to_csv(f"..\\data\\{file_name_to_get}_merged.csv")

            files_data_as_tuples_list = execute_with_confirmation(
                f"=== Get all files data with the {file_name_to_get} name with the {file_header} headers in a tuples list function ===",
                get_files_data, root_directory, file_name_to_get=file_name_to_get, return_type="tuples")

            files_total_occurrences = get_file_occurrences(root_directory, file_name_to_get)

            execute_with_confirmation(
                f"=== Insert all files data with the {file_name_to_get} name with the {file_header} headers into database function ===",
                insert_into_database, root_directory, files_name_to_insert=file_name_to_get,
                files_total_occurrences=files_total_occurrences)


if __name__ == "__main__":
    print()
    main()
