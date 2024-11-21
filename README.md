
# Bash Sticker Maker

Bash Sticker Maker is a simple Bash-based toolset for converting GIF files into optimized WebM video stickers. This repository is ideal for creating lightweight, animated stickers suitable for various messaging platforms. It utilizes `ffmpeg` and `ffprobe` to handle video encoding and optimization.

## Features

- **Input/Output Control**: Specify input GIFs and output WebM files.
- **Customizable Parameters**: Set max FPS, resolution, file size, and duration limits.
- **Batch Processing**: Process multiple GIFs simultaneously, with control over concurrent jobs.
- **Optimization**: Automatically resizes, crops, and adjusts the duration of stickers.
- **Size Validation**: Ensures stickers meet file size requirements by iteratively re-encoding.

---

## Table of Contents

1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Scripts Overview](#scripts-overview)
5. [Examples](#examples)
6. [License](#license)

---

## Requirements

- **Linux/Unix-based system**
- `bash` (version 4.0 or newer)
- `ffmpeg` and `ffprobe` installed and accessible via the command line.
- Basic knowledge of Bash scripting.

---

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/bash-sticker-maker.git
    cd bash-sticker-maker
    ```

2. Ensure scripts are executable:
    ```bash
    chmod +x main.sh run.sh test.sh
    ```

3. Prepare your input files:
    - Place your input GIFs in the `in/` directory.
    - Ensure the `out/` directory exists for output WebM stickers:
      ```bash
      mkdir -p in out
      ```

---

## Usage

### Basic Conversion

To convert a single GIF to WebM:
```bash
./main.sh -i path/to/input.gif -o path/to/output.webm
```

### Batch Processing

To process multiple files:
1. Place all your GIF files in the `in/` directory.
2. Run:
   ```bash
   ./run.sh
   ```

### Testing

Run the test script to convert `input.gif` and observe the results:
```bash
./test.sh
```

---

## Scripts Overview

### `main.sh`

The core script for converting a single GIF to WebM. Features include:
- Resizing and cropping to maintain aspect ratio.
- Speed adjustments for duration constraints.
- Iterative re-encoding to meet file size limits.

#### Key Parameters
| Flag               | Description                                   |
|--------------------|-----------------------------------------------|
| `-i`, `--input`    | Path to the input GIF file.                  |
| `-o`, `--output`   | Path to the output WebM file.                |
| `--max-fps`        | Maximum FPS for the output file (default: 30).|
| `--max-duration`   | Maximum duration in seconds (default: 3).    |
| `--max-size-px`    | Maximum resolution for the largest side (px).|
| `--max-output-size`| Maximum file size in KB (default: 256).      |

### `run.sh`

A batch processor to handle all GIFs in the `in/` directory. It:
- Spawns concurrent jobs (default: 5 max).
- Monitors and limits the number of running jobs.
- Outputs results to the `out/` directory.

### `test.sh`

A helper script to test sticker creation with a sample input GIF. Provides feedback on:
- Resized dimensions.
- Speedup adjustments.
- Final FPS and file size.

---

## Examples

### Convert a Single GIF
```bash
./main.sh -i sample.gif -o sample.webm --max-fps 20 --max-duration 2 --max-size-px 512 --max-output-size 300
```

### Process All GIFs in a Directory
```bash
./run.sh
```

### Verify Output
Inspect output files:
```bash
ls out/
```

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Feel free to reach out with questions or suggestions. Happy coding! 🎉
