[⬅ Back to Main Repo](../README.md)

# How to Reset and Combine Partitions on a Flash Drive (Ventoy/VTOYEFI)

This guide explains how to completely wipe a USB flash drive that has multiple stubborn partitions (like the `VTOYEFI` partition created by Ventoy) and combine them back into a single, usable drive.

**⚠️ WARNING: This process will completely erase ALL data on the flash drive. Back up your files before proceeding!**

## Part 1: Wipe and Rebuild the Drive using Diskpart

1. **Open Command Prompt as Administrator**
   - Click the Windows Start menu.
   - Type `cmd`.
   - Right-click on **Command Prompt** and select **Run as administrator**.

2. **Launch Diskpart**
   - In the command prompt, type the following and press **Enter**:
     ```cmd
     diskpart
     ```

3. **Identify Your Flash Drive**
   - Type the following to list all connected drives:
     ```cmd
     list disk
     ```
   - Look at the list and identify your flash drive based on its size (e.g., 28 GB). Note the **Disk ###** number next to it.

4. **Select the Flash Drive**
   - Type the following command, replacing `#` with the number of your flash drive:
     ```cmd
     select disk #
     ```
   - _CRITICAL: Double-check that you selected the correct disk number to avoid erasing your computer's main hard drive._

5. **Wipe the Drive**
   - To completely remove all partitions, type:
     ```cmd
     clean
     ```

6. **Create a New Partition**
   - Create a single new partition spanning the entire drive:
     ```cmd
     create partition primary
     ```

7. **Format the Drive (Choose Your File System)**
   - Format the partition using one of the following file systems based on your needs:

     **Option A: exFAT (Recommended)**
     Best for transferring large files (over 4GB) between Windows and Mac computers.

     ```cmd
     format fs=exfat quick
     ```

     **Option B: FAT32**
     Maximum compatibility with older devices, 3D printers, game consoles, and car audio systems. _Note: Cannot store individual files larger than 4GB._

     ```cmd
     format fs=fat32 quick
     ```

     **Option C: NTFS**
     Best if you exclusively use Windows computers. Supports large files, but Mac computers can only read (not write to) NTFS drives natively.

     ```cmd
     format fs=ntfs quick
     ```

## Part 2: Assign a Specific Drive Letter

You can assign a specific letter (like `Z`) to the newly formatted drive either through `diskpart` or Windows Disk Management.

### Option A: Using Diskpart (if still open from Part 1)

Instead of typing just `assign`, specify the letter by typing:

```cmd
assign letter=Z
```

_(Replace `Z` with any available letter you prefer. Avoid `C`)._
Type `exit` to close Diskpart.

### Option B: Using Windows Disk Management (Graphical Interface)

If you already closed the command prompt, it is easier to do this visually:

1. Right-click the Windows Start button and select **Disk Management**.
2. Find your flash drive in the bottom list.
3. Right-click on its main partition and select **Change Drive Letter and Paths...**
4. Click the **Change...** button.
5. Open the drop-down menu on the right and select the specific letter you want to use.
6. Click **OK**, and then click **Yes** to confirm the warning prompt.
