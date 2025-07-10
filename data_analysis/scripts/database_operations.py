import oracledb
import getpass
from datetime import datetime


def printf(*arg, **kwarg):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}]", *arg, **kwarg)


def get_database_connection(database_password=None):
    if database_password is None:
        database_password = getpass.getpass("Enter database password: ")
    connection = oracledb.connect(user="C##_behavioural_biometrics_user", password=database_password,
                                  dsn="localhost/FREE")
    printf("Successfully connected to Oracle database")

    return connection


def init(cursor):
    cursor.execute("drop table if exists Activity cascade constraints")
    printf("Successfully dropped Activity table")

    cursor.execute("create table Activity ("
                   "ID NUMBER(15),"
                   "SubjectID NUMBER(6),"
                   "Session_number NUMBER(2),"
                   "Start_time NUMBER(13),"
                   "End_time NUMBER(13),"
                   "Relative_Start_time NUMBER(10),"
                   "Relative_End_time NUMBER(10),"
                   "Gesture_scenario NUMBER(1),"
                   "TaskID NUMBER(2),"
                   "ContentID NUMBER(1)"
                   ")")
    printf("Successfully created Activity table")

    cursor.execute("drop table if exists Accelerometer")
    printf("Successfully dropped Accelerometer table")

    cursor.execute("create table Accelerometer ("
                   "Systime NUMBER(13),"
                   "EventTime NUMBER(15),"
                   "ActivityID NUMBER(15),"
                   "X NUMBER(17, 15),"
                   "Y NUMBER(17, 15),"
                   "Z NUMBER(17, 15),"
                   "Phone_orientation NUMBER(1)"
                   ")")
    printf("Successfully created Accelerometer table")

    cursor.execute("drop table if exists Gyroscope")
    printf("Successfully dropped Gyroscope table")

    cursor.execute("create table Gyroscope ("
                   "Systime NUMBER(13),"
                   "EventTime NUMBER(15),"
                   "ActivityID NUMBER(15),"
                   "X NUMBER(17, 15),"
                   "Y NUMBER(17, 15),"
                   "Z NUMBER(17, 15),"
                   "Phone_orientation NUMBER(1)"
                   ")")
    printf("Successfully created Gyroscope table")

    cursor.execute("drop table if exists Magnetometer")
    printf("Successfully dropped Magnetometer table")

    cursor.execute("create table Magnetometer ("
                   "Systime NUMBER(13),"
                   "EventTime NUMBER(15),"
                   "ActivityID NUMBER(15),"
                   "X NUMBER(10, 5),"
                   "Y NUMBER(10, 5),"
                   "Z NUMBER(10, 5),"
                   "Phone_orientation NUMBER(1)"
                   ")")
    printf("Successfully created Magnetometer table")

    cursor.execute("drop table if exists TouchEvent")
    printf("Successfully dropped TouchEvent table")

    cursor.execute("create table TouchEvent ("
                   "Systime NUMBER(25),"
                   "EventTime NUMBER(15),"
                   "ActivityID NUMBER(15),"
                   "Pointer_count NUMBER(1),"
                   "PointerID NUMBER(1),"
                   "ActionID NUMBER(1),"
                   "X NUMBER(10, 5),"
                   "Y NUMBER(10, 5),"
                   "Pressure NUMBER(8, 6),"
                   "Contact_size NUMBER(8, 6),"
                   "Phone_orientation NUMBER(1)"
                   ")")
    printf("Successfully created TouchEvent table")

    cursor.execute("drop table if exists KeyPressEvent")
    printf("Successfully dropped KeyPressEvent table")

    cursor.execute("create table KeyPressEvent ("
                   "Systime NUMBER(13),"
                   "PressTime NUMBER(10),"
                   "ActivityID NUMBER(15),"
                   "PressType NUMBER(1),"
                   "KeyID NUMBER(4),"
                   "Phone_orientation NUMBER(1)"
                   ")")
    printf("Successfully created KeyPressEvent table")

    cursor.execute("drop table if exists OneFingerTouchEvent")
    printf("Successfully dropped OneFingerTouchEvent table")

    cursor.execute("create table OneFingerTouchEvent ("
                   "Systime NUMBER(13),"
                   "PressTime NUMBER(10),"
                   "ActivityID NUMBER(15),"
                   "TapID NUMBER(4),"
                   "Tap_type NUMBER(1),"
                   "Action_type NUMBER(1),"
                   "X NUMBER(10, 5),"
                   "Y NUMBER(10, 5),"
                   "Pressure NUMBER(8, 6),"
                   "Contact_size NUMBER(8, 6),"
                   "Phone_orientation NUMBER(1)"
                   ")")
    printf("Successfully created OneFingerTouchEvent table")

    cursor.execute("drop table if exists PinchEvent")
    printf("Successfully dropped PinchEvent table")

    cursor.execute("create table PinchEvent ("
                   "Systime NUMBER(13),"
                   "PressTime NUMBER(10),"
                   "ActivityID NUMBER(15),"
                   "EventType NUMBER(1),"
                   "PinchID NUMBER(4),"
                   "Time_delta NUMBER(5),"
                   "Focus_X NUMBER(10, 5),"
                   "Focus_Y NUMBER(10, 5),"
                   "Span NUMBER(10, 5),"
                   "Span_X NUMBER(10, 5),"
                   "Span_Y NUMBER(10, 5),"
                   "ScaleFactor NUMBER(8, 6),"
                   "Phone_orientation NUMBER(1)"
                   ")")
    printf("Successfully created PinchEvent table")

    cursor.execute("drop table if exists ScrollEvent")
    printf("Successfully dropped ScrollEvent table")

    cursor.execute("create table ScrollEvent ("
                   "Systime NUMBER(13),"
                   "BeginTime NUMBER(10),"
                   "CurrentTime NUMBER(10),"
                   "ActivityID NUMBER(15),"
                   "ScrollID NUMBER(4),"
                   "Start_action_type NUMBER(1),"
                   "Start_X NUMBER(5),"
                   "Start_Y NUMBER(5),"
                   "Start_pressure NUMBER(8, 6),"
                   "Start_size NUMBER(8, 6),"
                   "Current_action_type NUMBER(1),"
                   "Current_X NUMBER(10, 5),"
                   "Current_Y NUMBER(10, 5),"
                   "Current_pressure NUMBER(8, 6),"
                   "Current_size NUMBER(8, 6),"
                   "Distance_X NUMBER(10, 6),"
                   "Distance_Y NUMBER(10, 6),"
                   "Phone_orientation NUMBER(1)"
                   ")")
    printf("Successfully created ScrollEvent table")

    cursor.execute("drop table if exists StrokeEvent")
    printf("Successfully dropped StrokeEvent table")

    cursor.execute("create table StrokeEvent ("
                   "Systime NUMBER(13),"
                   "Begin_time NUMBER(10),"
                   "End_time NUMBER(10),"
                   "ActivityID NUMBER(15),"
                   "Start_action_type NUMBER(1),"
                   "Start_X NUMBER(5),"
                   "Start_Y NUMBER(5),"
                   "Start_pressure NUMBER(8, 6),"
                   "Start_size NUMBER(8, 6),"
                   "End_action_type NUMBER(1),"
                   "End_X NUMBER(10, 5),"
                   "End_Y NUMBER(10, 5),"
                   "End_pressure NUMBER(8, 6),"
                   "End_size NUMBER(12, 9),"
                   "Speed_X NUMBER(12, 6),"
                   "Speed_Y NUMBER(12, 6),"
                   "Phone_orientation NUMBER(1)"
                   ")")
    printf("Successfully created StrokeEvent table")


def insert_into_table(cursor, table_name, data_to_insert, file_metadata):
    if not data_to_insert:
        return

    datasets_total_occurrences, datasets_processed_number, file_full_path = file_metadata

    columns_number = len(data_to_insert[0])
    placeholders = ", ".join(f":{i + 1}" for i in range(columns_number))
    sql = f"insert into {table_name} values ({placeholders})"

    cursor.executemany(sql, data_to_insert)
    printf(
        f"Successfully inserted {len(data_to_insert)} rows in the {table_name} table from {file_full_path} file - {datasets_processed_number}/{datasets_total_occurrences} datasets completed.")


def alter_tables(cursor):
    cursor.execute("alter table Activity drop column Gesture_scenario")
    cursor.execute("alter table Activity drop column TaskID")
    printf("Successfully dropped Activity's Gesture_scenario and TaskID columns")

    cursor.execute("drop table Accelerometer")
    printf("Successfully dropped Accelerometer table")

    cursor.execute("drop table Gyroscope")
    printf("Successfully dropped Gyroscope table")

    cursor.execute("drop table Magnetometer")
    printf("Successfully dropped Magnetometer table")

    # It is always 1
    cursor.execute("alter table TouchEvent drop column Pressure")
    printf("Successfully dropped TouchEvent's Pressure column")

    # It is always 1
    cursor.execute("alter table OneFingerTouchEvent drop column Pressure")
    printf("Successfully dropped OneFingerTouchEvent's Pressure column")

    cursor.execute("drop table PinchEvent")
    printf("Successfully dropped PinchEvent table")

    # They always have the same value
    cursor.execute("alter table ScrollEvent drop column Start_action_type")
    cursor.execute("alter table ScrollEvent drop column Start_pressure")
    cursor.execute("alter table ScrollEvent drop column Current_action_type")
    cursor.execute("alter table ScrollEvent drop column Current_pressure")
    printf(
        "Successfully dropped ScrollEvent's (Start_action_type, Start_pressure, Current_action_type, Current_pressure) columns")

    # They always have the same value
    cursor.execute("alter table StrokeEvent drop column Start_action_type")
    cursor.execute("alter table StrokeEvent drop column Start_pressure")
    cursor.execute("alter table StrokeEvent drop column End_action_type")
    cursor.execute("alter table StrokeEvent drop column End_pressure")
    printf(
        "Successfully dropped StrokeEvent's (Start_action_type, Start_pressure, End_action_type, End_pressure) columns")


def read_from_database(cursor, table_names):
    results = []
    for table_name in table_names:
        results.append(cursor.execute(f"select * from {table_name}").fetchall())

    return results


def read_from_table_after_timestamp(cursor, table_name, timestamp_ms):
    results = cursor.execute(f"select * from {table_name} where SYSTIME > {timestamp_ms}").fetchall()

    return results


def get_last_timestamp(cursor):
    last_timestamp = cursor.execute("select last_timestamp from ProcessedRows").fetchone()

    return last_timestamp[0]


def update_last_timestamp(cursor, new_last_timestamp):
    current_last_timestamp = get_last_timestamp(cursor)
    if new_last_timestamp > current_last_timestamp:
        cursor.execute(f"UPDATE ProcessedRows SET last_timestamp = {new_last_timestamp}")


def main():
    with get_database_connection() as connection:
        with connection.cursor() as cursor:
            execute_init = 0
            execute_alter = 0

            if execute_init == 1:
                init(cursor)

            if execute_alter == 1:
                alter_tables(cursor)


if __name__ == "__main__":
    print()
    main()
