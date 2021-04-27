########################################################################################################################
#!!
#! @description: Retrieves the list of files in the directory matching the pattern.
#!               The returned list will contain forward slashes or back slashes depending on what the input pattern contains.
#!
#! @input pattern: Full path and pattern which files to include; e.g. C:/Temp/*.txt
#! @input full_path: If false, only base file names are returned
#!
#! @output files: List of files in the directory matching the pattern
#!!#
########################################################################################################################
namespace: io.cloudslang.base.filesystem
operation:
  name: list_files
  inputs:
    - pattern
    - full_path: 'true'
  python_action:
    script: |-
      import glob, os
      files_list = glob.glob(pattern)
      if full_path == 'true':
          files = [str(x) for x in files_list]
      else:
          files = [str(os.path.basename(x)) for x in files_list]
      files = str(files)
  outputs:
    - files: '${files}'
  results:
    - SUCCESS
