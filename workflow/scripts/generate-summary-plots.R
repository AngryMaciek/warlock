###############################################################################
#
#   Small wrapper to plot all Muller plots for warlock simulations.
#
#   AUTHOR: Maciek Bak
#   AFFILIATION: City, University of London
#   CONTACT: wsciekly.maciek@gmail.com
#   CREATED: 23.11.2022
#   LICENSE: Apache_2.0
#
###############################################################################

Sys.setenv("LANGUAGE"="EN")

# by default: suppress warnings
options(warn = -1)

# load libraries
suppressPackageStartupMessages(suppressWarnings(library(demonanalysis)))
suppressPackageStartupMessages(suppressWarnings(library(optparse)))

# list the command-line arguments
option_list <- list(
  make_option(c("--input"),
    action = "store_true",
    dest = "input_directory",
    type = "character",
    help = "Path to the warlock output directory."
  ),
  make_option(c("--output"),
    action = "store_true",
    dest = "output_directory",
    type = "character",
    help = "Path for the output directory with plots."
  ),
  make_option(c("--help"),
    action = "store_true",
    dest = "help",
    type = "logical",
    default = FALSE,
    help = "Show this information and exit."
  ),
  make_option(c("--verbose"),
    action = "store_true",
    dest = "verbose",
    type = "logical",
    default = FALSE,
    help = "Run in verbose mode."
  )
)

# parse command-line arguments
opt_parser <- OptionParser(
  usage = "Usage: %prog [OPTIONS] --message [STRING]",
  option_list = option_list,
  add_help_option = FALSE,
  description = ""
)
opt <- parse_args(opt_parser)

# if verbose flag was set: print warnings
if (opt$verbose) {
  options(warn = 0)
}

###############################################################################
# MAIN
###############################################################################

fileConn = file(file.path(opt$output_directory, "muller.txt"))

tryCatch({
  plot_all_images(
    path = opt$input_directory,
    output_filename = "muller",
    output_dir = opt$output_directory
  )
  writeLines("muller plots: OK | see file: muller.png", fileConn)
}, error = function(e) {
  # print the error message to the stderr
  message(conditionMessage(e))
  writeLines("muller plots: ERROR | see error stream", fileConn)
})

close(fileConn)
