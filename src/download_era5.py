from typing import Dict, Any
import cdsapi

def download_era5(
    request: Dict[str, Any],
    area: list[float],
    output_file: str,
    test: bool = True
    ) -> str:

    output_file = f'{request["dataset"]}_{request["variable"]}_{request["year"]}.grib'
    
    if not test:
        client = cdsapi.Client()
        client.retrieve(request["dataset"], request, output_file)
        return output_file
    else:
        print(f"Request: {request} to {output_file}")
        return output_file
