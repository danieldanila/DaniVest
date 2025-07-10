from pydantic import BaseModel


class StrokeEventRaw(BaseModel):
    Systime: int
    Begin_time: int
    End_time: int
    ActivityID: int
    Start_X: float
    Start_Y: float
    Start_size: float
    End_X: float
    End_Y: float
    End_size: float
    Speed_X: float
    Speed_Y: float
    Phone_orientation: int