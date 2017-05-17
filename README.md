The ZipCPU is a fully-functional, soft-core CPU built for FPGA environments
by Gisselquist Technology, LLC.

The ZipCPU was initially designed with the sole purpose of creating a simple
CPU within an FPGA, and particularly one that was powerful enough to run Linux.
Reasons for this include:

1. I couldn't afford the FPGA board that I really wanted, the
[VC707](https://www.xilinx.com/products/boards-and-kits/ek-v7-vc707-g.html),
much less the license I would need to program it. 
Instead, I could afford the much smaller boards, such as the ones 
[Digilent](https://store.digilentinc.com) sells.
2. Prior to purchasing any boards or licenses, I simulated my designs
using [Verilator](https://www.veripool.org/wiki/verilator).  However, Verilator
only works with Verilog, not encrypted proprietary IP.  Hence, when I wanted to
simulate an FFT with neither hardware nor proprietary IP, I was forced to
[build my own](https://github.com/ZipCPU/dblclockfft).  The same became true
for the [ZipCPU](https://github.com/ZipCPU/zipcpu).  Incidentally, the "simulate
before you buy" technique worked so well for
[my first board](https://store.digilentinc.com/basys-3-artix-7-fpga-trainer-board-recommended-for-introductory-users),
that I had my initial design running within two days after I received the board.
3. I wanted to know how to build a CPU.  Somehow, in that initial excitement,
I forgot that building a CPU would also entail building backends for
[the C-library](https://sourceware.org/newlib), 
[GCC](https://gcc.gnu.org) and
[binutils](https://www.gnu.org/software/binutils)
([GDB](https://www.gnu.org/s/gdb) soon to come), but I've learned along the way.
4. I'm still hoping to integrate an optional MMU, and with it to run Linux,
but this feature remains sometime in the future.

While the ZipCPU was the result of my own desire to learn how CPU's operate,
now that it has been built it solves many of the problems that many of the more
proprietary CPU's struggle with.

- Because the ZipCPU is completely open source,
[opensource tools](https://www.veripool.org/wiki/verilator)
may be used to simulate and run the CPU--even without an FPGA.

  -- Your CPU power is the limit of this simulation.  As an example, you could,
   if you wished to, run the [CMod-S6](https://github.com/ZipCPU/s6soc)
   [simulation](https://github.com/ZipCPU/s6soc/blob/master/sim/verilator/zip_sim.cpp)
   all the way from power up through several rounds of
   [4x4x4 Tic-Tac-Toe](https://github.com/ZipCPU/tttt).  (Just don't run it in
   debug mode all night, at the peril of filling up your disk drive.)

  -- In a similar fashion, the ZipCPU is not tied to
   [Altera](https:www.altera.com), [Xilinx](https://www.xilinx.com), nor
   its more recent port to the [Lattice](https://www.latticesemi.com) iCE40
   FPGA's.

  -- Hence, it offers more flexibility than either
[MicroBlaze](https://www.xilinx.com/products/design-tools/microblaze.html) or
[Nios2](https://www.altera.com/products/processors/overview.html).

- Because the ZipCPU was designed to be simple, it can be
  [a component](https://github.com/ZipCPU/s6soc)
  on a very small FPGA, such as the Spartan 6LX4 used in the
  [Digilent's](https://store.digilentinc.com)
  [CMod S6](https://store.digilentinc.com/store.digilentinc.com/cmod-s6-breadboardable-spartan-6-fpga-module).

- Since the ZipCPU was designed around the pipelined
   [Wishbone bus](http://opencores.org/opencores,wishbone), found within the
  [Wishbone B4 specification](http://opencores.org/cdn/downloads/wbspec_b4.pdf),
  the ZipCPU enjoys memory accesses that are between three and thirty times
  faster than the [OpenRISC](https://openrisc.io) core.  (Their cache
  implementation is still better than mine, though ...)  Further, because of
  the many, many options and channels required in order to implement the
  [AXI bus](http://www.gstitt.ece.ufl.edu/courses/fall15/eel4720_5721/labs/refs/AXI4_specification.pdf) used by
  [Xilinx](https://www.xilinx.com)'s IP, the wishbone is simpler and hence both
  easier to work with, and it requires less logic to use.

- Because Gisselquist Technology, LLC, owns all of the code for the ZipCPU and
its peripherals, proprietary licenses may be purchased.  This sets the ZipCPU
apart from the other OpenSource soft core CPUs, such as
[OpenRISC](https://openrisc.io), whose IP may
not be owned by any single entity with whom one might negotiate a purchase.

## ZipCPU Examples
In many ways, the [ZipCPU](https://github.com/ZipCPU/zipcpu) is just that: a
CPU.  You can find out many of the details of this CPU within the 
[ZipCPU](https://github.com/ZipCPU/zipcpu) repository on
[GitHub](https://github.com).  There, you
will find the [specification for the CPU](https://github.com/ZipCPU/zipcpu/blob/master/doc/spec.pdf)
which contains not only the obligatory description
of its instruction set, but also examples of how to program with it as well as
my ongoing "honest assessment" of it as a CPU.

Since the ZipCPU is only a component of a larger
design, please feel free to examine some of our designs that use it.  These
include the [S6SoC](https://github.com/ZipCPU/s6soc) which fits on the
[Xilinx](https://www.xilinx.com) Spartan-6LX4 found within a
[Digilent](https://store.digilentinc.com)
[CMod S6](https://store.digilentinc.com/store.digilentinc.com/cmod-s6-breadboardable-spartan-6-fpga-module),
the [OpenArty](https://github.com/ZipCPU/openarty) which fits on a
[Digilent](https://store.digilentinc.com)
[Arty](https://store.digilentinc.com/arty-artix-7-fpga-development-board-for-makers-and-hobbyists/),
or the [xulalx25soc](https://github.com/ZipCPU/xulalx25soc) which fits on
[Xess.com](https://xess.com)'s
[XuLA2-LX25](https://xess.com/shop/product/xula2-lx25/) board.  Upon customer
request, the [xulalx25soc](https://github.com/ZipCPU/xulalx25soc) can also be
built for the Spartan-6LX9 on the XuLA2-LX9 board which
[Xess.com](https://xess.com) used to sell.

## Gisselquist Technology, LLC
Gisselquist Technology, LLC, is a small, services oriented business specializing
in both embedded or FPGA solutions as well as digital signal processing
solutions.  We have but one employee, Dan Gisselquist (that's me!).   I have a
[Ph.D. in Electrical Engineering](http://www.dtic.mil/dtic/tr/fulltext/u2/a423141.pdf) from the
[U.S. Air Force Institute of Technology](http://www.afit.edu),
a [Master's of Science in Computer Engineering](http://www.dtic.mil/dtic/tr/fulltext/u2/a289401.pdf) from the same, and two Bachelor
of Science degrees, one in Mathematics and the other in Computer Science, from
the [U.S. Air Force Academy](http://usafa.edu).  While I am not the greatest guru out there, I do take a particular joy in solving problems that others cannot solve, and I like to think of this as Gisselquist Technology's niche.


Gisselquist Technology is founded upon a couple of values:

- We are a Bible believing, Christian based company.

  -- We are closed on Sundays

  -- We don't lie about the performance of competing systems, and we don't hide our own faults

- Debt free.  Please don't offer us a business loan, I get enough annoying
 phone calls as it is.

- We create our own Open Source software, FPGA designs and design components.

  -- While all of our software and designs are available under the
   [GPLv3 license](https://www.gnu.org/licenses/gpl-3.0.en.html), they may
   also be purchased under other licenses.  Terms are negotiable.  Both
   proprietary and MIT style licenses may be purchased, although the MIT
   license will be more expensive. 


