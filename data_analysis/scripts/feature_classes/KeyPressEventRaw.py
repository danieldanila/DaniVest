from pydantic import BaseModel


class KeyPressEventRaw(BaseModel):
    Systime: int
    PressTime: int
    ActivityID: int
    PressType: int
    KeyID: int
    Phone_orientation: int
