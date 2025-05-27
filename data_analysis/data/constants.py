relevant_files_from_hmog_dataset = ["Activity.csv", "Accelerometer.csv", "Gyroscope.csv", "Magnetometer.csv",
                                    "TouchEvent.csv", "KeyPressEvent.csv", "OneFingerTouchEvent.csv", "PinchEvent.csv",
                                    "ScrollEvent.csv", "StrokeEvent.csv"
                                    ]

file_headers_from_hmog_dataset = [["ID", "SubjectID", "Session_number", "Start_time", "End_time", "Relative_Start_time",
                                   "Relative_End_time", "Gesture_scenario", "TaskID", "ContentID"],
                                  ["Systime", "EventTime", "ActivityID", "X", "Y", "Z", "Phone_orientation"],
                                  ["Systime", "EventTime", "ActivityID", "X", "Y", "Z", "Phone_orientation"],
                                  ["Systime", "EventTime", "ActivityID", "X", "Y", "Z", "Phone_orientation"],
                                  ["Systime", "EventTime", "ActivityID", "Pointer_count", "PointerID", "ActionID", "X",
                                   "Y",
                                   "Pressure", "Contact_size", "Phone_orientation"],
                                  ["Systime", "PressTime", "ActivityID", "PressType", "KeyID", "Phone_orientation"],
                                  ["Systime", "PressTime", "ActivityID", "TapID", "Tap_type", "Action_type", "X", "Y",
                                   "Pressure",
                                   "Contact_size", "Phone_orientation"],
                                  ["Systime", "PressTime", "ActivityID", "EventType", "PinchID", "Time_delta",
                                   "Focus_X", "Focus_Y",
                                   "Span", "Span_X", "Span_Y", "ScaleFactor", "Phone_orientation"],
                                  ["Systime", "BeginTime", "CurrentTime", "ActivityID", "ScrollID", "Start_action_type",
                                   "Start_X",
                                   "Start_Y", "Start_pressure", "Start_size", "Current_action_type", "Current_X",
                                   "Current_Y",
                                   "Current_pressure", "Current_size", "Distance_X", "Distance_Y", "Phone_orientation"],
                                  ["Systime", "Begin_time", "End_time", "ActivityID", "Start_action_type", "Start_X",
                                   "Start_Y",
                                   "Start_pressure", "Start_size", "End_action_type", "End_X", "End_Y", "End_pressure",
                                   "End_size",
                                   "Speed_X", "Speed_Y", "Phone_orientation"]
                                  ]

relevant_tables = [relevant_files_from_hmog_dataset[0][:-4],
                   relevant_files_from_hmog_dataset[4][:-4],
                   relevant_files_from_hmog_dataset[5][:-4],
                   relevant_files_from_hmog_dataset[6][:-4],
                   relevant_files_from_hmog_dataset[8][:-4],
                   relevant_files_from_hmog_dataset[9][:-4]
                   ]

table_headers = [
    [x for x in file_headers_from_hmog_dataset[0] if x not in ["Gesture_scenario", "TaskID"]],
    [x for x in file_headers_from_hmog_dataset[4] if x not in ["Pressure"]],
    file_headers_from_hmog_dataset[5],
    [x for x in file_headers_from_hmog_dataset[6] if x not in ["Pressure"]],
    [x for x in file_headers_from_hmog_dataset[8] if
     x not in ["Start_action_type", "Start_pressure", "Current_action_type", "Current_pressure"]],
    [x for x in file_headers_from_hmog_dataset[9] if
     x not in ["Start_action_type", "Start_pressure", "End_action_type", "End_pressure"]]
]
