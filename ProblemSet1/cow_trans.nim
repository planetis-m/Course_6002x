import tables, strutils
from partition import get_partitions

#================================
# Part A: Transporting Space Cows
#================================


proc loadCows(filename: string): Table[string, int] =
    # Read the contents of the given file.  Assumes the file contents contain
    # data in the form of comma-separated cow name, weight pairs, and return a
    # dictionary containing cow names as keys and corresponding weights as values.
    #
    # Parameters:
    # filename - the name of the data file as a string
    #
    # Returns:
    # a dictionary of cow name (string), weight (int) pairs
    result = initTable[string, int]()
    var f = open(filename, fmRead)
    for line in f.lines:
        let line_data = line.split(',')
        result[line_data[0]] = parseInt(line_data[1])
    close(f)


# Problem 1
proc greedyCowTransport(cows: Table[string, int]; limit = 10): seq[seq[string]] =
    # Uses a greedy heuristic to determine an allocation of cows that attempts to
    # minimize the number of spaceship trips needed to transport all the cows. The
    # returned allocation of cows may or may not be optimal.
    # The greedy heuristic should follow the following method:
    #
    # 1. As long as the current trip can fit another cow, add the largest cow that will fit
    #     to the trip
    # 2. Once the trip is full, begin a new trip to transport the remaining cows
    #
    # Does not mutate the given dictionary of cows.
    #
    # Parameters:
    # cows - a dictionary of name (string), weight (int) pairs
    # limit - weight limit of the spaceship (an int)
    #
    # Returns:
    # A list of lists, with each inner list containing the names of cows
    # transported on a particular trip and the overall list containing all the
    # trips

    


# Problem 2
proc bruteForceCowTransport(cows: Table[string, int]; limit = 10): seq[seq[string]] =
    # Finds the allocation of cows that minimizes the number of spaceship trips
    # via brute force.  The brute force algorithm should follow the following method:
    #
    # 1. Enumerate all possible ways that the cows can be divided into separate trips
    # 2. Select the allocation that minimizes the number of trips without making any trip
    #     that does not obey the weight limitation
    #
    # Does not mutate the given dictionary of cows.
    #
    # Parameters:
    # cows - a dictionary of name (string), weight (int) pairs
    # limit - weight limit of the spaceship (an int)
    #
    # Returns:
    # A list of lists, with each inner list containing the names of cows
    # transported on a particular trip and the overall list containing all the
    # trips

    


# Problem 3
proc compareCowTransportAlgorithms() =

    # Using the data from ps1_cow_data.txt and the specified weight limit, run your
    # greedy_cow_transport and brute_force_cow_transport functions here. Use the
    # default weight limits of 10 for both greedy_cow_transport and
    # brute_force_cow_transport.
    #
    # Print out the number of trips returned by each method, and how long each
    # method takes to run in seconds.
    #
    # Returns:
    # Does not return anything.

    


# Here is some test data for you to see the results of your algorithms with. 
# Do not submit this along with any of your answers. Uncomment the last two
# lines to print the result of your problem.

let cows = load_cows("cow_data.txt")
let limit = 100
echo cows

echo greedyCowTransport(cows, limit)
echo bruteForceCowTransport(cows, limit)
