#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtb_top.h"

#define MAX_SIM_TIME 11*2
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
  Vtb_top *dut = new Vtb_top;

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  dut->trace(m_trace, 5);
  m_trace->open("tb_top.vcd");

  while (sim_time < MAX_SIM_TIME)
  {
   dut->reset = 0;
   if ( sim_time < 1*2 )
   {
      dut->reset = 1;
   }
     std::cout << "NOTE: "
               << "led = " << (int)( dut->led )
               << " simtime = " << sim_time << std::endl;
      dut->clk ^= 1;
      dut->eval();
      m_trace->dump(sim_time);
      sim_time++;
  } // while

  m_trace->close();
  delete dut;
  exit(EXIT_SUCCESS);
}
