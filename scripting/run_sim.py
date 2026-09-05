'''
import subprocess

result = subprocess.run(
    ["vsim", "-c", "-do", "run.do"],
    capture_output=True,
    text=True
)

print(result.stdout)
print(result.stderr)

print("Return code:", result.returncode)
'''
'''
import subprocess

result = subprocess.run(
    ["vsim", "-c", "-do", "run.do"],
    capture_output=True,
    text=True
)

with open("spi_run.log", "w") as log_file:
    log_file.write(result.stdout)
    log_file.write(result.stderr)

print("Simulation completed.")
print("Return code:", result.returncode)
print("Log saved to spi_run.log")
'''
import subprocess
import re

result = subprocess.run(
    ["vsim", "-c", "-do", "run.do"],
    capture_output=True,
    text=True
)

print(result.stdout)
print(result.stderr)
print("Return code:", result.returncode)

with open("spi_run.log", "w") as log_file:
    log_file.write(result.stdout)
    log_file.write(result.stderr)

log_text = result.stdout + result.stderr

if re.search(r"TEST PASSED", log_text):
    status = "PASS"
elif re.search(r"TEST FAILED", log_text):
    status = "FAIL"
else:
    status = "UNKNOWN"

print("Simulation completed.")
print("Return code:", result.returncode)
print("Test status:", status)