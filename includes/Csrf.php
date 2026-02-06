<?php
// includes/Csrf.php
// Requires SessionManager (SessionManager::start() must be called before using Csrf)
class Csrf {
    // token lifetime in seconds
    private const TOKEN_LIFETIME = 3600;
    // session key where tokens are stored
    private const SESSION_KEY = '_csrf';

    /**
     * Generate a token for a given form name (empty string allowed).
     * Stores single token per form (overwrites previous).
     * Returns token string.
     */
    public static function generateToken(string $form = ''): string {
        // make sure session is available
        // (SessionManager::start() should already have been called)
        $token = bin2hex(random_bytes(32));
        $expires = time() + self::TOKEN_LIFETIME;

        $all = SessionManager::get(self::SESSION_KEY, []);
        $all[$form] = ['token' => $token, 'expires' => $expires];
        SessionManager::set(self::SESSION_KEY, $all);

        return $token;
    }

    /**
     * Return an HTML string with hidden inputs for the CSRF token and form name.
     * Use directly inside your <form> markup.
     */
    public static function getTokenField(string $form = ''): string {
        $token = self::generateToken($form);
        // include form identifier so server can know which token to check
        $formEsc = htmlspecialchars($form, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
        $tokenEsc = htmlspecialchars($token, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');

        return '<input type="hidden" name="csrf_token" value="' . $tokenEsc . '">' .
               '<input type="hidden" name="csrf_form" value="' . $formEsc . '">';
    }

    /**
     * Validate a given token for a form. Consumes token on success.
     * Returns true if valid, false otherwise.
     */
    public static function validateToken(?string $token, string $form = ''): bool {
        if (empty($token)) {
            return false;
        }

        $all = SessionManager::get(self::SESSION_KEY, []);
        if (!isset($all[$form]) || !is_array($all[$form])) {
            return false;
        }

        $entry = $all[$form];

        // expired?
        if (!isset($entry['expires']) || $entry['expires'] < time()) {
            // clean up expired token
            unset($all[$form]);
            SessionManager::set(self::SESSION_KEY, $all);
            return false;
        }

        // constant-time compare
        $valid = hash_equals($entry['token'], $token);
        if ($valid) {
            // consume token (single-use)
            unset($all[$form]);
            SessionManager::set(self::SESSION_KEY, $all);
            return true;
        }

        return false;
    }

    /**
     * Validate current request (POST). Reads csrf_token and csrf_form from $_POST by default.
     * Returns true if valid, false otherwise.
     * Optionally sets a flash message on failure.
     */
    public static function validateRequest(string $expectedForm = ''): bool {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return false;
        }

        $token = $_POST['csrf_token'] ?? null;
        $form = $_POST['csrf_form'] ?? $expectedForm;

        $ok = self::validateToken($token, (string)$form);
        if (!$ok) {
            // optional: set a flash message
            SessionManager::setFlash('error', 'Invalid or expired form submission (CSRF). Please try again.');
        }
        return $ok;
    }

    /**
     * For APIs or AJAX: validate using header 'X-CSRF-Token' and optional form param.
     * Returns true if valid, false otherwise.
     */
    public static function validateHeader(string $form = ''): bool {
        $token = null;
        // PSR-7/Apache: HTTP_X_CSRF_TOKEN, or direct header
        if (!empty($_SERVER['HTTP_X_CSRF_TOKEN'])) {
            $token = $_SERVER['HTTP_X_CSRF_TOKEN'];
        } elseif (!empty($_SERVER['HTTP_X_CSRFTOKEN'])) {
            $token = $_SERVER['HTTP_X_CSRFTOKEN'];
        }
        return self::validateToken($token, $form);
    }
}
