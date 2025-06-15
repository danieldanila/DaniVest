from pydantic import BaseModel


class ScrollEvent(BaseModel):
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
    scroll_length_euclidean_distance: float
    scroll_angle: float
    contact_size_avg: float
    distance_x_avg: float
    distance_y_avg: float
    direction: int
    magnitude_speed: float
    phone_orientation: int