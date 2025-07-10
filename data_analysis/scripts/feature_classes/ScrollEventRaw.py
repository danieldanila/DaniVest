from pydantic import BaseModel


class ScrollEventRaw(BaseModel):
    Systime: int
    BeginTime: int
    CurrentTime: int
    ActivityID: int
    ScrollID: int
    Start_X: float
    Start_Y: float
    Start_size: float
    Current_X: float
    Current_Y: float
    Current_size: float
    Distance_X: float
    Distance_Y: float
    Phone_orientation: int