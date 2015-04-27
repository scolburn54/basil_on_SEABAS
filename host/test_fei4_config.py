#
# ------------------------------------------------------------
# Copyright (c) All rights reserved
# SiLab, Institute of Physics, University of Bonn
# ------------------------------------------------------------
#

import yaml
import time
import numpy as np
from bitarray import bitarray

from basil.dut import Dut  


class Pixel(Dut):
    """
    A class for communicating with a pixel chip.

    """
    
    def program_global_reg(self):
        """
        Send the global register to the chip.

        Loads the values of self['GLOBAL_REG'] onto the chip.
        Includes enabling the clock, and loading the Control (CTR)
        and DAC shadow registers.

        """

	print "here 3"
        
        self._clear_strobes()
        
        gr_size = len(self['GLOBAL_REG'][:]) #get the size
        self['SEQ']['SHIFT_IN'][0:gr_size] = self['GLOBAL_REG'][:] # this will be shifted out
        self['SEQ']['GLOBAL_SHIFT_EN'][0:gr_size] = bitarray( gr_size * '1') #this is to enable clock
        self['SEQ']['GLOBAL_CTR_LD'][gr_size+1:gr_size+2] = bitarray("1") # load signals
        self['SEQ']['GLOBAL_DAC_LD'][gr_size+1:gr_size+2] = bitarray("1")
        
        
        # Execute the program (write bits to output pins)
        # + 1 extra 0 bit so that everything ends on LOW instead of HIGH
        self._run_seq(gr_size+3)
    
    def program_pixel_reg(self, enable_receiver=True):
        """
        Send the pixel register to the chip and store the output.

        Loads the values of self['PIXEL_REG'] onto the chip.
        Includes enabling the clock, and loading the Control (CTR)
        and DAC shadow registers.

        if(enable_receiver), stores the output (by byte) in
        self['DATA'], retrievable via `chip['DATA'].get_data()`.

        """
	
	print "here 4"
        
        self._clear_strobes()

        #enable receiver it work only if pixel register is enabled/clocked
        self['PIXEL_RX'].set_en(enable_receiver) 

        px_size = len(self['PIXEL_REG'][:]) #get the size
        self['SEQ']['SHIFT_IN'][0:px_size] = self['PIXEL_REG'][:] # this will be shifted out
        self['SEQ']['PIXEL_SHIFT_EN'][0:px_size] = bitarray( px_size * '1') #this is to enable clock
        
        print 'px_size', px_size
        
        
        self._run_seq(px_size+1) #add 1 bit more so there is 0 at the end other way will stay high
            
    def _run_seq(self, size):
        """
        Send the contents of self['SEQ'] to the chip and wait until it finishes.

        """

	print "here 5"
        
        # Write the sequence to the sequence generator (hw driver)
        self['SEQ'].write(size) #write pattern to memory
        
        self['SEQ'].set_size(size)  # set size
        self['SEQ'].set_repeat(1) # set repeat
        for _ in range(1):
            self['SEQ'].start() # start
            
            while not self['SEQ'].get_done():
                #time.sleep(0.1)
                print "Wait for done..."

    def _clear_strobes(self):
        """
        Resets the "enable" and "load" output streams to all 0.

        """
	
	print "here 6"
	
        #reset some stuff
        self['SEQ']['GLOBAL_SHIFT_EN'].setall(False)
        self['SEQ']['GLOBAL_CTR_LD'].setall(False)
        self['SEQ']['GLOBAL_DAC_LD'].setall(False)
        self['SEQ']['PIXEL_SHIFT_EN'].setall(False)
        self['SEQ']['INJECTION'].setall(False)

# Read in the configuration YAML file
stream = open("pyBAR_SEABAS.yaml", 'r')
cnfg = yaml.load(stream)

# Create the Pixel object
dut = Dut(cnfg)
dut.init()

# enabling readout
dut['rx']['CH1'] = 1
dut['rx']['CH2'] = 1
dut['rx']['CH3'] = 1
dut['rx']['CH4'] = 1
dut['rx']['TLU'] = 1
dut['rx']['TDC'] = 1
dut['rx'].write()

def cmd(data, size):
    dut['cmd']['CMD_SIZE'] = size
    dut['cmd'].set_data(data)
    dut['cmd']['START']
    
    while not dut['cmd']['READY']:
        pass
    
cmd([0xB4, 0x10, 0x37, 0x00, 0x00], 39) # settings PLL
cmd([0xB4, 0x10, 0x38, 0x04, 0x0C], 39) #settings PLL
cmd([0xB4, 0x50, 0x70], 23) # run mode
cmd([0xB1, 0x00], 9) # ECR
cmd([0xB4, 0x50, 0x0E], 23) # conf mode  


