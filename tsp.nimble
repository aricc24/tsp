
#Package configuration for the TSP project using the Threshold Acceptance
#metaheuristic.

#It defines the project metadata, source directory, Nim version requirement,
#and external dependencies.


# Package

version       = "0.1.0"
author        = "aricc24"
description = "Traveling Salesman Problem using the Threshold Acceptance metaheuristic"
license       = "UNAM"
srcDir        = "src"


# Dependencies

requires "nim >= 2.2.10"

requires "db_connector"