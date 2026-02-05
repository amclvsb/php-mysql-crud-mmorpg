<?php

abstract class Database {
    protected $connection;
    protected $query;
    protected $show_errors = true;
    protected $query_closed = true;
    public $query_count = 0;

    // Database credentials - usually pulled from a config file
    private $dbhost = 'localhost';
    private $dbuser = 'root';
    private $dbpass = '';
    private $dbname = 'crime_empire';
    private $charset = 'utf8mb4';

    /**
     * Constructor: Automatically connects to the database
     */
    public function __construct() {
        $this->connection = new mysqli($this->dbhost, $this->dbuser, $this->dbpass, $this->dbname);

        if ($this->connection->connect_error) {
            $this->error('Failed to connect to MySQL - ' . $this->connection->connect_error);
        }
        
        $this->connection->set_charset($this->charset);
    }

    /**
     * Prepared Statement Execution
     * Usage: $this->query("SELECT * FROM users WHERE id = ?", $id);
     */
    public function query($query) {
        if (!$this->query_closed) {
            $this->query->close();
        }
        
        if ($prepare = $this->connection->prepare($query)) {
            if (func_num_args() > 1) {
                $x = func_get_args();
                $args = array_slice($x, 1);
                $types = '';
                foreach ($args as $arg) {
                    if (is_int($arg)) $types .= 'i';
                    elseif (is_double($arg)) $types .= 'd';
                    elseif (is_string($arg)) $types .= 's';
                    else $types .= 'b';
                }
                $prepare->bind_param($types, ...$args);
            }

            $prepare->execute();
            $this->query = $prepare;
            $this->query_closed = false;
            $this->query_count++;
        } else {
            $this->error('Unable to prepare statement: ' . $query);
        }
        
        return $this;
    }

    /**
     * Fetch all results as an associative array
     */
    public function fetchAll() {
        $result = $this->query->get_result();
        $data = $result->fetch_all(MYSQLI_ASSOC);
        $this->query->close();
        $this->query_closed = true;
        return $data;
    }

    /**
     * Fetch a single row
     */
    public function fetchArray() {
        $result = $this->query->get_result();
        $data = $result->fetch_assoc();
        $this->query->close();
        $this->query_closed = true;
        return $data;
    }

    /**
     * Helper for basic updates/inserts
     */
    public function affectedRows() {
        return $this->query->affected_rows;
    }

    public function insertId() {
        return $this->connection->insert_id;
    }

    /**
     * Basic sanitization for non-prepared strings
     */
    public function escape($string) {
        return $this->connection->real_escape_string($string);
    }

    /**
     * Error handling
     */
    private function error($error) {
        if ($this->show_errors) {
            exit('<div style="background:#fee; border:1px solid #f00; padding:10px;"><strong>Database Error:</strong> ' . $error . '</div>');
        }
    }

    public function close() {
        return $this->connection->close();
    }
}
