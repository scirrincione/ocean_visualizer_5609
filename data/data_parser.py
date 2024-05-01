import csv
import sys

data = []

def parse_data(lines):
    cast_data = {}
    variables_section = False
    for line in lines:
        line = line.strip()
        if line.startswith("Prof-Flag"):
            variables_section = True

        if line.startswith("CAST"):
            data.append(cast_data)
            cast_data["cast_number"] = line.split(",")[2].strip()
        elif line.startswith("Year"):
            cast_data["year"] = line.split(",")[2].strip()
        elif line.startswith("Latitude"):
            cast_data["latitude"] = line.split(",")[2].strip()
        elif line.startswith("Longitude"):
            cast_data["longitude"] = line.split(",")[2].strip()
        elif line.startswith("1") and variables_section:
            cast_data["temperature"] = line.split(",")[4].strip()
            cast_data["oxygen"] = line.split(",")[7].strip()
            cast_data["pH"] = line.split(",")[10].strip()
            cast_data["chlorophyl"] = line.split(",")[13].strip()
            variables_section = False
            cast_data = {}


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]

    with open(filename, "r") as file:
        lines = file.readlines()
        parse_data(lines)

    output_filename = "parsed_" + filename.split(".")[0] + ".csv"
    with open(output_filename, "w", newline="") as csvfile:
        fieldnames = ["cast_number", "year", "latitude", "longitude", "temperature", "oxygen", "pH", "chlorophyl"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        
        writer.writeheader()
        for d in data:
            writer.writerow(d)