# Experiment 07 — ADC0804 to DAC0830 (Motor Speed Control) | 8086 + Proteus

This project implements **Experiment 07 (Application 2)**: sampling an analog signal using **ADC0804**, waiting for conversion completion by polling the **/INTR** line, and forwarding the digital result to **DAC0830** to generate an analog output suitable for **motor speed control** in a Proteus simulation.

## Key Idea
- Trigger ADC conversion (write to ADC control/data port).
- **Poll /INTR via D7** on a memory-mapped status port until it becomes **0** (conversion complete).
- Read ADC result and write it to DAC output.

## Memory-Mapped I/O Map
| Device/Signal | Address | Notes |
|---|---:|---|
| DAC0830 | `0x200` | Analog output driven from sampled ADC value |
| ADC0804 | `0x400` | Conversion trigger + data read |
| ADC0804 `/INTR` (buffered) | `0x800` | Connected to **D7** (bit 7); **0 = ready** |

## How It Works (Algorithm)
1. Write a dummy value to `0x400` to start ADC conversion.
2. Repeatedly read `0x800` and test bit 7:
   - if D7 = 1 → conversion in progress
   - if D7 = 0 → conversion finished
3. Read the ADC value from `0x400`.
4. Output the same byte to DAC via `0x200`.
5. Repeat in an infinite loop.

## Project Contents
- `src/adc_dac_motor_control.asm` — 8086 assembly implementation
- `proteus/` — Proteus design files and screenshots
- `docs/Deney7_ADC-DAC_Sorusu.pdf` — experiment specification

## Build / Run
### Option A — Using MASM/TASM + DOSBox (typical)
1. Assemble and link:
   - `tasm adc_dac_motor_control.asm`
   - `tlink adc_dac_motor_control.obj`
2. Use the generated `.EXE` in Proteus (8086 program property) or run via DOSBox depending on your setup.

### Option B — Using your course toolchain
If your course provides a specific assembler/linker workflow, follow that and only replace the source file with `src/adc_dac_motor_control.asm`.

## Simulation Notes (Proteus)
- Ensure address decoding maps devices exactly as listed above.
- `/INTR` must be buffered and routed to **D7** of the `0x800` read port.
- Screenshots of expected behavior are in `proteus/screenshots/`.

## Results
- As the light source approaches the LDR, the sampled value increases and the DAC output increases accordingly, resulting in higher motor speed (in the provided motor block model).
