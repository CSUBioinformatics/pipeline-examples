cwlVersion: v1.0 # required 
class: CommandLineTool # required
doc: |
    This is an example of a command line tool in CWL. A general purpose script is available:
    https://github.com/common-workflow-language/workflows/
    This one is not general purpose, but demonstrates various ways you can use CWL to build a 
    command. This has some more advanced uses of CWL so I recommend checking out the user guide.
# specify that this tool needs node.js to run javascript expressions we use later
requirements:
 - class: InlineJavascriptRequirement
# base command is placed first on the command line
baseCommand: java

# arguments are placed after baseCommand if no position
# is specified and are not values given by the user
arguments:
- valueFrom: "PE"
  position: 2
  # see sample_name under inputs field
- valueFrom: ${ return inputs.sample_name + "_paired_R1.fastq"; }
  position: 5
- valueFrom: ${ return inputs.sample_name + "_paired_R2.fastq"; }
  position: 6
- valueFrom: ${ return inputs.sample_name + "_unpaired_R1.fastq"; }
  position: 7
- valueFrom: ${ return inputs.sample_name + "_unpaired_R2.fastq"; }
  position: 8

# inputs are placed next if there isn't an arguments field
# or position fields are not specified. Inputs are provided
# by the user 
inputs:
  # this takes the trimmomatic.jar as input and places it
  # after '-jar' and in the first position after baseCommand:
  jar_file:
    type: File
    inputBinding:
      position: 1
      prefix: -jar
  forward:
    type: File
    inputBinding:
      position: 3
  reverse:
    type: File
    inputBinding:
      position: 4
  # not all inputs need to be put directly in the command, we 
  # can instead use the sample name to build arguments (above)
  # for the output files
  sample_name:
    type: string
  # This is simplified to match the others, so the values for
  # illuminaClip are not able to be modified by a user. See the 
  # official version for how this is done
  adapters:
    type: File
    inputBinding:
      valueFrom: ${ return "ILLUMINACLIP:" + self.path + ":2:30:10:3:TRUE"; }
      position: 9
  # you can set default values for inputs
  leading:
    type: int
    inputBinding: 
      position: 10
      prefix: "LEADING:"
      separate: False
    default: 3
  trailing:
    type: int
    inputBinding:
      position: 11
      prefix: "TRAILING:"
      separate: False
  sliding_window:
    type: string
    inputBinding:
      position: 12
      prefix: "SLIDINGWINDOW:"
      separate: False
    default: "4:15"
  # set optional inputs using ?
  min_len:
    type: int?
    inputBinding:
      position: 13
      prefix: "MINLEN:"
      separate: False
# the outputs field determines what outputs to return
outputs:
  # specify an array of type using []
  trimmed_files:
    type: File[]
    outputBinding:
      glob: 
        - $(inputs.sample_name)_paired_R1.fastq
        - $(inputs.sample_name)_paired_R2.fastq
        - $(inputs.sample_name)_unpaired_R1.fastq
        - $(inputs.sample_name)_unpaired_R2.fastq
