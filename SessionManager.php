<?php

abstract class SessionManager {
    
    /**
     * Start a secure session with modern cookie settings
     */
    public static function start($lifetime = 14400, $path = '/', $domain = null, $secure = false) {
        if (session_status() === PHP_SESSION_NONE) {
            // Security: Prevent session IDs from being passed in URLs
            ini_set('session.use_only_cookies', 1);
            ini_set('session.use_strict_mode', 1);

            session_set_cookie_params([
                'lifetime' => $lifetime,
                'path'     => $path,
                'domain'   => $domain,
                'secure'   => $secure,    // Set true if using HTTPS
                'httponly' => true,      // Prevents JS from accessing session ID
                'samesite' => 'Lax'
            ]);

            session_start();
        }
    }

    /**
     * Set a session value
     */
    public static function set(string $key, $value): void {
        $_SESSION[$key] = $value;
    }

    /**
     * Get a session value with an optional default
     */
    public static function get(string $key, $default = null) {
        return $_SESSION[$key] ?? $default;
    }

    /**
     * Check if a key exists
     */
    public static function has(string $key): bool {
        return isset($_SESSION[$key]);
    }

    /**
     * Remove a specific key
     */
    public static function delete(string $key): void {
        if (self::has($key)) {
            unset($_SESSION[$key]);
        }
    }

    /**
     * Regenerate session ID to prevent Session Fixation attacks
     * Call this whenever a player logs in or changes rank
     */
    public static function regenerate(): void {
        session_regenerate_id(true);
    }

    /**
     * Flash Messages: Useful for the alerts in your City Search script
     * Stores a message that disappears after being read once
     */
    public static function setFlash(string $type, string $message): void {
        $_SESSION['_flash'][$type] = $message;
    }

    public static function getFlash(): array {
        $flash = $_SESSION['_flash'] ?? [];
        unset($_SESSION['_flash']); // Clear after retrieving
        return $flash;
    }

    /**
     * Fully destroy the session (Logout)
     */
    public static function destroy(): void {
        $_SESSION = [];
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
