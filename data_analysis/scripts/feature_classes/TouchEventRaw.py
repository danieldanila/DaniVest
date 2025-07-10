from pydantic import BaseModel


class TouchEventRaw(BaseModel):
    Systime: int
    EventTime: int
    ActivityID: int
    Pointer_count: int
    PointerID: int
    ActionID: int
    X: float
    Y: float
    Contact_size: float
    Phone_orientation: int