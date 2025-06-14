import numpy as np


# Screen example
# +-----------+-----------+
# |           |           |
# |    Box 1  |   Box 2   |
# |           |           |
# |-----------+-----------|
# |           |           |
# |   Box 3   |   Box 4   |
# |           |           |
# +-----------+-----------+
def get_quadrant(x, y, max_x, max_y):
    half_screen_x = max_x / 2
    half_screen_y = max_y / 2

    if x < half_screen_x and y < half_screen_y:
        return 1  # Top-left
    elif x >= half_screen_x and y < half_screen_y:
        return 2  # Top-right
    elif x < half_screen_x and y >= half_screen_y:
        return 3  # Bottom-left
    else:
        return 4  # Bottom-right


# Magnitude = sqrt(Speed_X^2 + Speed_Y^2)
def get_magnitude_speed(speed_x, speed_y):
    return np.sqrt(speed_x ** 2 + speed_y ** 2)


def get_movement_direction(speed_x, speed_y):
    if speed_x > 0 and speed_y > 0:
        return 0  # "down-right"
    elif speed_x < 0 and speed_y > 0:
        return 1  # "down-left"
    elif speed_x > 0 and speed_y < 0:
        return 2  # "up-right"
    elif speed_x < 0 and speed_y < 0:
        return 3  # "up-left"
    else:
        return 4  # "straight"


# Euclidean distance = sqrt((End_X - Start_X)² + (End_Y - Start_Y)²)
def get_euclidean_distance(start_x, start_y, end_x, end_y):
    return np.sqrt((end_x - start_x) ** 2 + (end_y - start_y) ** 2)


# Angle = atan2(End_Y - Start_Y, End_X - Start_X)
def get_angle(start_x, start_y, end_x, end_y):
    return np.atan2(end_y - start_y, end_x - start_x)
