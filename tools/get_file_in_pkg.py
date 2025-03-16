import argparse
from importlib import metadata

parser = argparse.ArgumentParser(
    description='Get the path of a file installed by a Python package'
)

parser.add_argument('filename', type=str, help='name of the file to search for')
parser.add_argument('--pkg', type=str, required=True, help='name of the Python package')
parser.add_argument('--parent', action='store_true', help='return the directory path')

args = parser.parse_args()

try:
    pkg_files = metadata.files(args.pkg)
    path = next(p for p in pkg_files if args.filename in str(p))
    resolved_path = path.locate().resolve()
    print(resolved_path.parent if args.parent else resolved_path)

except metadata.PackageNotFoundError:
    msg = f'No package {args.pkg} was found'
    raise FileNotFoundError(msg) from None

except StopIteration:
    msg = f'No file {args.filename} was found for {args.pkg}'
    raise FileNotFoundError(msg) from None
