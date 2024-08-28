import os
import sys
import argparse
from pathlib import Path
import trimesh
import pyvista as pv


def parse_arguments():
    parser = argparse.ArgumentParser(description="Preprocess files for use in signed DNE python package. Generate watertight versions and clean up")
    parser.add_argument("input", nargs='+', help="Path to mesh or directory containing mesh files")
    return parser.parse_args()


def get_file_names(input_paths):
    file_names = []
    for path in input_paths:
        p = Path(path)
        if p.is_dir():
            file_names.extend(p.rglob('*'))
        elif p.is_file():
            file_names.append(p)
        else:
            print(str(p) + " is not a file a or a directory")
    return [f for f in file_names if f.is_file()]#[f for f in file_names if f.suffix in ('.ply', '.obj')]


def close_holes(tm_mesh):
    pv_mesh = pv.wrap(tm_mesh)

    filled_mesh = pv_mesh.fill_holes(hole_size=float('inf'))

    vertices = filled_mesh.points
    faces = filled_mesh.faces.reshape((-1, 4))[:, 1:]
    tm_closed_mesh = trimesh.Trimesh(vertices=vertices, faces=faces)
    tm_closed_mesh.fix_normals()

    return tm_closed_mesh


def preprocess_file(file_name):
    mesh = trimesh.load(file_name)
    
    # Simple clean up
    mesh.fill_holes()
    mesh.update_faces(mesh.nondegenerate_faces(height=1e-08))
    mesh.update_faces(mesh.unique_faces())
    mesh.remove_infinite_values()
    mesh.remove_unreferenced_vertices()
    mesh.export(file_name)

    mesh = close_holes(mesh)
    base_name, extension = os.path.splitext(file_name)
    mesh.export(f"{base_name}_watertight{extension}")

    # ms = pymeshlab.MeshSet()
    # ms.load_new_mesh(file_name)
    # ms.meshing_remove_duplicate_vertices()
    # ms.meshing_remove_duplicate_faces()
    # ms.meshing_remove_folded_faces()
    # ms.meshing_remove_null_faces()
    # ms.meshing_remove_unreferenced_vertices()
    # ms.save_current_mesh(file_name)
    # ms.meshing_close_holes(
    #         maxholesize=10000000,
    #         selected=False,
    #         newfaceselected=True, 
    #         selfintersection=False,
    #         refinehole=True,
    #     )
    # base_name, extension = os.path.splitext(file_name)
    # new_file_name = f"{base_name}_watertight{extension}"
    # ms.save_current_mesh(new_file_name)


def main():
    args = parse_arguments()
    file_names = get_file_names(args.input)

    if not file_names:
        print("No files found in the specified input(s).")
        sys.exit(1)
    
    num_processed = len(file_names)
    for file_name in file_names:
        try:
            preprocess_file(str(file_name))
        except Exception as e:
            num_processed -= 1
            print("Failed to preprocess " + str(file_name) + ": " + str(e))
    
    
    print("Cleaned and generated watertight versions of " + str(num_processed) + " files")


if __name__ == '__main__':
    main()
