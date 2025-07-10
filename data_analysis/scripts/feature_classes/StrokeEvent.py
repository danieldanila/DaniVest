from pydantic import BaseModel


class StrokeEvent(BaseModel):
    activity_id: int
    user_id: int
    session_number: int
    start_timestamps: int
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
    stroke_length_euclidean_distance: float
    stroke_angle: float
    start_size: float
    end_size: float
    contact_size_avg: float
    speed_x: float
    speed_y: float
    direction: float
    magnitude_speed: float
    phone_orientation: float