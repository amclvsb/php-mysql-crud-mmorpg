<?php

/**
 * Singleton Database Class to manage the database connection.
 */
class Database
{
    private static ?Database $instance = null;
    private mysqli $connection;

    // Configuration settings (ideally, load these from environment variables)
    private string $host = 'localhost';
    private string $username = 'root';
    private string $password = '';
    private string $dbname = 'app_db';

    /**
     * Private constructor to prevent direct instantiation.
     */
    private function __construct()
    {
        $this->connection = new mysqli($this->host, $this->username, $this->password, $this->dbname);

        if ($this->connection->connect_error) {
            die("Database Connection Failed: " . $this->connection->connect_error);
        }
    }

    /**
     * Get the single instance of the Database class.
     * @return Database
     */
    public static function getInstance(): Database
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Get the mysqli connection object.
     * @return mysqli
     */
    public function getConnection(): mysqli
    {
        return $this->connection;
    }

    // Prevent cloning and unserialization
    private function __clone() {}
    public function __wakeup() { throw new Exception("Cannot unserialize a singleton."); }
}

class Authentication
{
    /**
     * Registers a new user.
     * @param string $username The desired username.
     * @param string $password The plain text password.
     * @return array Result containing 'success' (bool) and 'message' (string).
     */
    public static function register(string $username, string $password): array
    {
        if (empty($username) || empty($password)) {
            return ['success' => false, 'message' => 'Username and password are required.'];
        }

        $db = Database::getInstance()->getConnection();

        // Check if username already exists
        $stmt = $db->prepare("SELECT id FROM users WHERE username = ?");
        if (!$stmt) {
            return ['success' => false, 'message' => 'Database error: ' . $db->error];
        }

        $stmt->bind_param("s", $username);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            $stmt->close();
            return ['success' => false, 'message' => 'Username already exists.'];
        }
        $stmt->close();

        // Hash the password (PHP handles salt generation automatically)
        $hash = password_hash($password, PASSWORD_DEFAULT);

        // Insert new user
        $insertStmt = $db->prepare("INSERT INTO users (username, password_hash) VALUES (?, ?)");
        if (!$insertStmt) {
            return ['success' => false, 'message' => 'Database error: ' . $db->error];
        }

        $insertStmt->bind_param("ss", $username, $hash);
        
        if ($insertStmt->execute()) {
            $insertStmt->close();
            return ['success' => true, 'message' => 'Registration successful.'];
        } else {
            $error = $insertStmt->error;
            $insertStmt->close();
            return ['success' => false, 'message' => 'Registration failed: ' . $error];
        }
    }

    /**
     * Authenticates a user and starts a session.
     * @param string $username The username.
     * @param string $password The plain text password.
     * @return bool True if login successful, false otherwise.
     */
    public static function login(string $username, string $password): bool
    {
        // Ensure session is started
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare("SELECT id, password_hash FROM users WHERE username = ? LIMIT 1");
        if (!$stmt) {
            return false;
        }

        $stmt->bind_param("s", $username);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($row = $result->fetch_object()) {
            // Verify password against stored hash
            if (password_verify($password, $row->password_hash)) {
                // Prevent session fixation
                session_regenerate_id(true);
                
                $_SESSION['user_id'] = $row->id;
                $_SESSION['username'] = $username;
                $_SESSION['logged_in'] = true;
                
                $stmt->close();
                return true;
            }
        }

        $stmt->close();
        return false;
    }

    /**
     * Checks if the current user is logged in.
     * @return bool
     */
    public static function check(): bool
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        return isset($_SESSION['logged_in']) && $_SESSION['logged_in'] === true;
    }

    /**
     * Retrieves the currently logged-in user's ID.
     * @return int|null
     */
    public static function id(): ?int
    {
        if (self::check()) {
            return $_SESSION['user_id'];
        }
        return null;
    }

    /**
     * Logs the user out and destroys the session.
     * @return void
     */
    public static function logout(): void
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        
        $_SESSION = array();

        if (ini_get("session.use_cookies")) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000,
                $params["path"], $params["domain"],
                $params["secure"], $params["httponly"]
            );
        }

        session_destroy();
    }
}
