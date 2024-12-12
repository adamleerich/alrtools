template_file <- './data-raw/test-template.txt'
test_template <- readChar(template_file, file.info(template_file)$size)

# Save to R/Sysdata.rda
usethis::use_data(test_template, internal = TRUE, overwrite = TRUE)



# [2024-12-11 ALR]
# Removed -- never used
#
# ## Define Euler's number
# e <- exp(1)
# usethis::use_data(e, internal = FALSE)
