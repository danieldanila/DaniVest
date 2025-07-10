from typing import TypeVar, List
from pydantic import BaseModel
import pandas as pd

T = TypeVar('T', bound=BaseModel)

def pydantic_list_to_dataframe(data: List[T]) -> pd.DataFrame:
    dict_list = [item.model_dump() for item in data]
    return pd.DataFrame(dict_list)