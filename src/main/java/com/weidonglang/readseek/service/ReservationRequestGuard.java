package com.weidonglang.readseek.service;

public interface ReservationRequestGuard {
    GuardToken acquire(Long userId, Long bookId);

    void release(GuardToken token);

    static ReservationRequestGuard noOp() {
        return new ReservationRequestGuard() {
            @Override
            public GuardToken acquire(Long userId, Long bookId) {
                return GuardToken.bypassed();
            }

            @Override
            public void release(GuardToken token) {
                // No-op fallback used by unit tests and non-Redis construction paths.
            }
        };
    }

    final class GuardToken {
        private final String key;
        private final String value;
        private final boolean redisBacked;

        private GuardToken(String key, String value, boolean redisBacked) {
            this.key = key;
            this.value = value;
            this.redisBacked = redisBacked;
        }

        public static GuardToken redis(String key, String value) {
            return new GuardToken(key, value, true);
        }

        public static GuardToken bypassed() {
            return new GuardToken(null, null, false);
        }

        public String getKey() {
            return key;
        }

        public String getValue() {
            return value;
        }

        public boolean isRedisBacked() {
            return redisBacked;
        }
    }
}
