package com.eventhorizon.util;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * FileHandler - Central utility for all file read/write operations.
 *
 * Data files (placed in /data/ folder of the project root):
 *   - users.txt
 *   - events.txt
 *   - bookings.txt
 *
 * Each line in a file = one record (CSV / pipe-separated).
 */
public class FileHandler {

    // ---------- File paths (adjust if your project structure differs) ----------
    private static final String DATA_DIR     = System.getProperty("user.home") + "/eventhorizon_data/";
    public  static final String USERS_FILE   = DATA_DIR + "users.txt";
    public  static final String EVENTS_FILE  = DATA_DIR + "events.txt";
    public  static final String BOOKINGS_FILE = DATA_DIR + "bookings.txt";

    // Create data directory and empty files if they don't exist
    static {
        File dir = new File(DATA_DIR);
        if (!dir.exists()) dir.mkdirs();

        createIfNotExists(USERS_FILE);
        createIfNotExists(EVENTS_FILE);
        createIfNotExists(BOOKINGS_FILE);
    }

    private static void createIfNotExists(String path) {
        File f = new File(path);
        try {
            if (!f.exists()) f.createNewFile();
        } catch (IOException e) {
            System.err.println("Could not create file: " + path);
        }
    }

    // ===========================  READ  ===========================

    /**
     * Reads all non-empty lines from a file and returns them as a List.
     */
    public static List<String> readAllLines(String filePath) {
        List<String> lines = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    lines.add(line);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading file: " + filePath + " | " + e.getMessage());
        }
        return lines;
    }

    // ===========================  WRITE (append)  ===========================

    /**
     * Appends a single line to a file (used for CREATE operations).
     */
    public static void appendLine(String filePath, String line) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true))) {
            bw.write(line);
            bw.newLine();
        } catch (IOException e) {
            System.err.println("Error writing to file: " + filePath + " | " + e.getMessage());
        }
    }

    // ===========================  WRITE (overwrite all)  ===========================

    /**
     * Overwrites the entire file with a new list of lines.
     * Used for UPDATE and DELETE operations.
     */
    public static void writeAllLines(String filePath, List<String> lines) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, false))) {
            for (String line : lines) {
                bw.write(line);
                bw.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing file: " + filePath + " | " + e.getMessage());
        }
    }

    // ===========================  DELETE (by ID prefix)  ===========================

    /**
     * Deletes the line whose first field (ID) matches the given id.
     * The delimiter can be "," or "|" depending on the file.
     */
    public static boolean deleteLine(String filePath, String id, String delimiter) {
        List<String> lines  = readAllLines(filePath);
        List<String> updated = new ArrayList<>();
        boolean found = false;

        for (String line : lines) {
            String firstField = line.split("\\" + delimiter)[0];
            if (firstField.equals(id)) {
                found = true;   // Skip this line → effectively deletes it
            } else {
                updated.add(line);
            }
        }

        if (found) writeAllLines(filePath, updated);
        return found;
    }

    // ===========================  UPDATE (by ID prefix)  ===========================

    /**
     * Replaces the line whose ID matches with a new line.
     */
    public static boolean updateLine(String filePath, String id,
                                     String newLine, String delimiter) {
        List<String> lines   = readAllLines(filePath);
        List<String> updated = new ArrayList<>();
        boolean found = false;

        for (String line : lines) {
            String firstField = line.split("\\" + delimiter)[0];
            if (firstField.equals(id)) {
                updated.add(newLine);   // Replace old line
                found = true;
            } else {
                updated.add(line);
            }
        }

        if (found) writeAllLines(filePath, updated);
        return found;
    }

    // ===========================  ID GENERATOR  ===========================

    /**
     * Generates the next sequential ID based on existing lines in a file.
     * e.g., prefix "EVT" → EVT001, EVT002, ...
     */
    public static String generateId(String filePath, String prefix) {
        List<String> lines = readAllLines(filePath);
        int count = lines.size() + 1;
        return String.format("%s%03d", prefix, count);
    }
}
