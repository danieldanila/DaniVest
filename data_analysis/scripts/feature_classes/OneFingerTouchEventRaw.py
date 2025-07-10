from pydantic import BaseModel


class OneFingerTouchEventRaw(BaseModel):
    Systime: int
    PressTime: int
    ActivityID: int
    TapID: int
    Tap_type: int
    Action_type: int
    X: float
    Y: float
    Contact_size: float
    Phone_orientation: int