# WirelessNet_challenge_ET4394

I have included the matlab file and the csv files to show the bitstream extracted from the encoded RFID responses.
For analysis of the generated bitstreams, I have taken help of [EPC Global Standard Specification for RFID](http://www.gs1.org/sites/default/files/docs/epc/uhfc1g2_1_2_0-standard-20080511.pdf)

The results of bitstreams along with decoded messages are displayed in the Matlab command window.
Following point are to be mentioned :
* Use (run 'file_name') command to run the matlab file in the matlab command window
* Make sure that the signal file is in the pwd( present working directory)
* For Display purposes preamble, tag data and training data is ignored
* For Analysis purposes entire signal trace is used.
* Four different figures of bitstreams will be generated corresponding to the R->T or T->R message
* The derived information is displayed in the form of results.
