# Grids

Utilities for working with 2D coordinate data such as maps, height fields,
and tile-based layouts.

## Overview

The grid model consists of two core types:

- ``Grid`` — a rectangular, bounds-checked 2D structure
- ``Cell`` — a lightweight `(row, col)` coordinate with neighbour helpers

These types are designed for pathfinding, flood-fill, map traversal,
and general AoC-style 2D problems.

## Topics

### Coordinates
- ``Cell``
- ``Cell/row``
- ``Cell/col``
- ``Cell/neighbours()``

### Grids
- ``Grid``
- ``Grid/init(rows:)``
- ``Grid/subscript(_:_:)``
- ``Grid/neighbours(_:)``

