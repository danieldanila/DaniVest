from pydantic import BaseModel


class OneFingerTouchEvent(BaseModel):
    activity_id: int
    user_id: int
    session_number: int
    start_timestamps: int
    scenario: int
    hour_sin: float
    hour_cos: float
    dow_sin: float
    dow_cos: float
    month_sin: float
    month_cos: float
    is_weekend: int
    part_of_day: int
    down_up_duration_ms: float
    down_down_duration_ms: float
    up_down_duration_ms: float
    start_x: float
    start_y: float
    end_x: float
    end_y: float
    start_quadrant: int
    end_quadrant: int
    X_coord_distance: float
    Y_coord_distance: float
    touch_length_euclidean_distance: float
    touch_angle: float
    contact_size_avg: float
    direction: int
    move_actions_second: int
    phone_orientation: int