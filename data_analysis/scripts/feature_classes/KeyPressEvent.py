from pydantic import BaseModel


class KeyPressEvent(BaseModel):
    session_duration_ms: int
    hour_sin: float
    hour_cos: float
    dow_sin: float
    dow_cos: float
    month_sin: float
    month_cos: float
    is_weekend: int
    down_up_duration_ms_avg: float
    down_down_duration_ms_avg: float
    up_down_duration_ms_avg: float
    total_unique_keys_used: int
    total_keys_pressed: int
    characters_per_second: float
    phone_orientation_0: bool
    phone_orientation_1: bool
    phone_orientation_3: bool
    part_of_day_0: bool
    part_of_day_3: bool
    part_of_day_4: bool
    part_of_day_5: bool