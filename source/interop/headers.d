module interop.headers;

        import core.stdc.config;
        import core.stdc.stdarg;
        static import core.simd;
        static import std.conv;

        struct Int128 { long lower; long upper; }
        struct UInt128 { ulong lower; ulong upper; }

        struct __locale_data { int dummy; }  // FIXME
    alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }
    // Replacement for the gcc/clang intrinsic
    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }
    // dmd bug causes a crash if T is passed by value.
    // Works fine with ldc.
    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(`    `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
        }
        private static string _enumMixinStr() {
            import std.array: join;
            string[] ret;
            ret ~= "enum " ~ name ~ "{";
            static foreach(member; __traits(allMembers, T)) {
                ret ~= _memberMixinStr(member);
            }
            ret ~= "}";
            return ret.join("\n");
        }
        mixin(_enumMixinStr());
    }
}
    
extern(C)
{
    
    double gpr_timespec_to_micros(gpr_timespec) @nogc nothrow;
    /** Sleep until at least 'until' - an absolute timeout */
    void gpr_sleep_until(gpr_timespec) @nogc nothrow;
    /** Return 1 if two times are equal or within threshold of each other,
   0 otherwise */
    int gpr_time_similar(gpr_timespec, gpr_timespec, gpr_timespec) @nogc nothrow;
    
    int32_t gpr_time_to_millis(gpr_timespec) @nogc nothrow;
    
    gpr_timespec gpr_time_from_hours(int64_t, gpr_clock_type) @nogc nothrow;
    
    gpr_timespec gpr_time_from_minutes(int64_t, gpr_clock_type) @nogc nothrow;
    
    gpr_timespec gpr_time_from_seconds(int64_t, gpr_clock_type) @nogc nothrow;
    
    gpr_timespec gpr_time_from_millis(int64_t, gpr_clock_type) @nogc nothrow;
    
    gpr_timespec gpr_time_from_nanos(int64_t, gpr_clock_type) @nogc nothrow;
    /** Return a timespec representing a given number of time units. INT64_MIN is
   interpreted as gpr_inf_past, and INT64_MAX as gpr_inf_future.  */
    gpr_timespec gpr_time_from_micros(int64_t, gpr_clock_type) @nogc nothrow;
    
    gpr_timespec gpr_time_sub(gpr_timespec, gpr_timespec) @nogc nothrow;
    /** Add and subtract times.  Calculations saturate at infinities. */
    gpr_timespec gpr_time_add(gpr_timespec, gpr_timespec) @nogc nothrow;
    
    gpr_timespec gpr_time_min(gpr_timespec, gpr_timespec) @nogc nothrow;
    
    gpr_timespec gpr_time_max(gpr_timespec, gpr_timespec) @nogc nothrow;
    /** Return -ve, 0, or +ve according to whether a < b, a == b, or a > b
   respectively.  */
    int gpr_time_cmp(gpr_timespec, gpr_timespec) @nogc nothrow;
    /** Convert a timespec from one clock to another */
    gpr_timespec gpr_convert_clock_type(gpr_timespec, gpr_clock_type) @nogc nothrow;
    /** Return the current time measured from the given clocks epoch. */
    gpr_timespec gpr_now(gpr_clock_type) @nogc nothrow;
    /** initialize time subsystem */
    void gpr_time_init() @nogc nothrow;
    /** The far past. */
    gpr_timespec gpr_inf_past(gpr_clock_type) @nogc nothrow;
    /** The far future */
    gpr_timespec gpr_inf_future(gpr_clock_type) @nogc nothrow;
    /** Time constants. */
/** The zero time interval. */
    gpr_timespec gpr_time_0(gpr_clock_type) @nogc nothrow;
    /** Analogous to struct timespec. On some machines, absolute times may be in
 * local time. */
    struct gpr_timespec
    {
        
        int64_t tv_sec;
        
        int32_t tv_nsec;
        /** Against which clock was this time measured? (or GPR_TIMESPAN if
      this is a relative time measure) */
        gpr_clock_type clock_type;
    }
    /** The clocks we support. */
    enum gpr_clock_type
    {
        /** Monotonic clock. Epoch undefined. Always moves forwards. */
        GPR_CLOCK_MONOTONIC = 0, 
        /** Realtime clock. May jump forwards or backwards. Settable by
     the system administrator. Has its epoch at 0:00:00 UTC 1 Jan 1970. */
        GPR_CLOCK_REALTIME = 1, 
        /** CPU cycle time obtained by rdtsc instruction on x86 platforms. Epoch
     undefined. Degrades to GPR_CLOCK_REALTIME on other platforms. */
        GPR_CLOCK_PRECISE = 2, 
        /** Unmeasurable clock type: no base, created by taking the difference
     between two times */
        GPR_TIMESPAN = 3, 
    }
    enum GPR_CLOCK_MONOTONIC = gpr_clock_type.GPR_CLOCK_MONOTONIC;
    enum GPR_CLOCK_REALTIME = gpr_clock_type.GPR_CLOCK_REALTIME;
    enum GPR_CLOCK_PRECISE = gpr_clock_type.GPR_CLOCK_PRECISE;
    enum GPR_TIMESPAN = gpr_clock_type.GPR_TIMESPAN;
    
    alias gpr_once = pthread_once_t;
    
    alias gpr_cv = pthread_cond_t;
    
    alias gpr_mu = pthread_mutex_t;
    
    struct gpr_stats_counter
    {
        
        gpr_atm value;
    }
    
    struct gpr_refcount
    {
        
        gpr_atm count;
    }
    
    struct gpr_event
    {
        
        gpr_atm state;
    }
    /** Return *c.  Requires: *c initialized. */
    intptr_t gpr_stats_read(const(gpr_stats_counter)*) @nogc nothrow;
    /** *c += inc.  Requires: *c initialized. */
    void gpr_stats_inc(gpr_stats_counter*, intptr_t) @nogc nothrow;
    /** Initialize *c to the value n. */
    void gpr_stats_init(gpr_stats_counter*, intptr_t) @nogc nothrow;
    /** Return non-zero iff the reference count of *r is one, and thus is owned
   by exactly one object. */
    int gpr_ref_is_unique(gpr_refcount*) @nogc nothrow;
    /** Decrement the reference count *r and return non-zero iff it has reached
   zero. .  Requires *r initialized. */
    int gpr_unref(gpr_refcount*) @nogc nothrow;
    /** Increment the reference count *r by n.  Requires *r initialized, n > 0. */
    void gpr_refn(gpr_refcount*, int) @nogc nothrow;
    /** Increment the reference count *r.  Requires *r initialized.
   Crashes if refcount is zero */
    void gpr_ref_non_zero(gpr_refcount*) @nogc nothrow;
    /** Increment the reference count *r.  Requires *r initialized. */
    void gpr_ref(gpr_refcount*) @nogc nothrow;
    /** Initialize *r to value n.  */
    void gpr_ref_init(gpr_refcount*, int) @nogc nothrow;
    /** Wait until *ev is set by gpr_event_set(ev, ...), or abs_deadline is
   exceeded, then return gpr_event_get(ev).  Requires:  *ev initialized.  Use
   abs_deadline==gpr_inf_future for no deadline.  When the event has been
   signalled before the call, this operation is faster than acquiring a mutex
   on most platforms.  */
    void* gpr_event_wait(gpr_event*, gpr_timespec) @nogc nothrow;
    /** Return the value set by gpr_event_set(ev, ...), or NULL if no such call has
   completed.  If the result is non-NULL, all operations that occurred prior to
   the gpr_event_set(ev, ...) set will be visible after this call returns.
   Requires:  *ev initialized.  This operation is faster than acquiring a mutex
   on most platforms.  */
    void* gpr_event_get(gpr_event*) @nogc nothrow;
    /** Set *ev so that gpr_event_get() and gpr_event_wait() will return value.
   Requires:  *ev initialized; value != NULL; no prior or concurrent calls to
   gpr_event_set(ev, ...) since initialization.  */
    void gpr_event_set(gpr_event*, void*) @nogc nothrow;
    /** Initialize *ev. */
    void gpr_event_init(gpr_event*) @nogc nothrow;
    /** Ensure that (*init_function)() has been called exactly once (for the
   specified gpr_once instance) and then return.
   If multiple threads call gpr_once() on the same gpr_once instance, one of
   them will call (*init_function)(), and the others will block until that call
   finishes.*/
    void gpr_once_init(gpr_once*, void function()) @nogc nothrow;
    /** Wake all threads waiting on *cv.  Requires:  *cv initialized.  */
    void gpr_cv_broadcast(gpr_cv*) @nogc nothrow;
    /** If any threads are waiting on *cv, wake at least one.
   Clients may treat this as an optimization of gpr_cv_broadcast()
   for use in the case where waking more than one waiter is not useful.
   Requires:  *cv initialized.  */
    void gpr_cv_signal(gpr_cv*) @nogc nothrow;
    /** Atomically release *mu and wait on *cv.  When the calling thread is woken
   from *cv or the deadline abs_deadline is exceeded, execute gpr_mu_lock(mu)
   and return whether the deadline was exceeded.  Use
   abs_deadline==gpr_inf_future for no deadline.  abs_deadline can be either
   an absolute deadline, or a GPR_TIMESPAN.  May return even when not
   woken explicitly.  Requires:  *mu and *cv initialized; the calling thread
   holds an exclusive lock on *mu.  */
    int gpr_cv_wait(gpr_cv*, gpr_mu*, gpr_timespec) @nogc nothrow;
    /** Cause *cv no longer to be initialized, freeing any memory in use.  Requires:
 *cv initialized; no other concurrent operation on *cv.*/
    void gpr_cv_destroy(gpr_cv*) @nogc nothrow;
    /** Initialize *cv.  Requires:  *cv uninitialized.  */
    void gpr_cv_init(gpr_cv*) @nogc nothrow;
    /** Without blocking, attempt to acquire an exclusive lock on *mu for the
   calling thread, then return non-zero iff success.  Fail, if any thread holds
   the lock; succeeds with high probability if no thread holds the lock.
   Requires:  *mu initialized.  */
    int gpr_mu_trylock(gpr_mu*) @nogc nothrow;
    /** Release an exclusive lock on *mu held by the calling thread.  Requires:  *mu
   initialized; the calling thread holds an exclusive lock on *mu.  */
    void gpr_mu_unlock(gpr_mu*) @nogc nothrow;
    /** Wait until no thread has a lock on *mu, cause the calling thread to own an
   exclusive lock on *mu, then return.  May block indefinitely or crash if the
   calling thread has a lock on *mu.  Requires:  *mu initialized.  */
    void gpr_mu_lock(gpr_mu*) @nogc nothrow;
    /** Cause *mu no longer to be initialized, freeing any memory in use.  Requires:
 *mu initialized; no other concurrent operation on *mu.  */
    void gpr_mu_destroy(gpr_mu*) @nogc nothrow;
    /** Initialize *mu.  Requires:  *mu uninitialized.  */
    void gpr_mu_init(gpr_mu*) @nogc nothrow;
    /** printf to a newly-allocated string.  The set of supported formats may vary
   between platforms.

   On success, returns the number of bytes printed (excluding the final '\0'),
   and *strp points to a string which must later be destroyed with gpr_free().

   On error, returns -1 and sets *strp to NULL. If the format string is bad,
   the result is undefined. */
    int gpr_asprintf(char**, const(char)*, ...) @nogc nothrow;
    /** Returns a copy of src that can be passed to gpr_free().
   If allocation fails or if src is NULL, returns NULL. */
    char* gpr_strdup(const(char)*) @nogc nothrow;
    
    void gpr_unreachable_code(const(char)*, const(char)*, int) @nogc nothrow;
    
    void gpr_assertion_failed(const(char)*, int, const(char)*) @nogc nothrow;
    
    void gpr_set_log_function(gpr_log_func) @nogc nothrow;
    alias gpr_log_func = void function(gpr_log_func_args*);
    /** Log overrides: applications can use this API to intercept logging calls
   and use their own implementations */
    struct gpr_log_func_args
    {
        
        const(char)* file;
        
        int line;
        
        gpr_log_severity severity;
        
        const(char)* message;
    }
    
    void gpr_log_verbosity_init() @nogc nothrow;
    /** Set global log verbosity */
    void gpr_set_log_verbosity(gpr_log_severity) @nogc nothrow;
    
    void gpr_log_message(const(char)*, int, gpr_log_severity, const(char)*) @nogc nothrow;
    
    int gpr_should_log(gpr_log_severity) @nogc nothrow;
    /** Log a message. It's advised to use GPR_xxx above to generate the context
 * for each message */
    void gpr_log(const(char)*, int, gpr_log_severity, const(char)*, ...) @nogc nothrow;
    /** Returns a string representation of the log severity */
    const(char)* gpr_log_severity_string(gpr_log_severity) @nogc nothrow;
    /** The severity of a log message - use the #defines below when calling into
   gpr_log to additionally supply file and line data */
    enum gpr_log_severity
    {
        
        GPR_LOG_SEVERITY_DEBUG = 0, 
        
        GPR_LOG_SEVERITY_INFO = 1, 
        
        GPR_LOG_SEVERITY_ERROR = 2, 
    }
    enum GPR_LOG_SEVERITY_DEBUG = gpr_log_severity.GPR_LOG_SEVERITY_DEBUG;
    enum GPR_LOG_SEVERITY_INFO = gpr_log_severity.GPR_LOG_SEVERITY_INFO;
    enum GPR_LOG_SEVERITY_ERROR = gpr_log_severity.GPR_LOG_SEVERITY_ERROR;
    
    alias gpr_atm = intptr_t;
    /** Adds \a delta to \a *value, clamping the result to the range specified
    by \a min and \a max.  Returns the new value. */
    gpr_atm gpr_atm_no_barrier_clamped_add(gpr_atm*, gpr_atm, gpr_atm, gpr_atm) @nogc nothrow;
    /** free memory allocated by gpr_malloc_aligned */
    void gpr_free_aligned(void*) @nogc nothrow;
    /** aligned malloc, never returns NULL, will align to alignment, which
 * must be a power of 2. */
    void* gpr_malloc_aligned(size_t, size_t) @nogc nothrow;
    /** realloc, never returns NULL */
    void* gpr_realloc(void*, size_t) @nogc nothrow;
    /** free */
    void gpr_free(void*) @nogc nothrow;
    /** like malloc, but zero all bytes before returning them */
    void* gpr_zalloc(size_t) @nogc nothrow;
    /** malloc.
 * If size==0, always returns NULL. Otherwise this function never returns NULL.
 * The pointer returned is suitably aligned for any kind of variable it could
 * contain.
 */
    void* gpr_malloc(size_t) @nogc nothrow;
    
    enum grpc_status_code
    {
        /** Not an error; returned on success */
        GRPC_STATUS_OK = 0, 
        /** The operation was cancelled (typically by the caller). */
        GRPC_STATUS_CANCELLED = 1, 
        /** Unknown error.  An example of where this error may be returned is
     if a Status value received from another address space belongs to
     an error-space that is not known in this address space.  Also
     errors raised by APIs that do not return enough error information
     may be converted to this error. */
        GRPC_STATUS_UNKNOWN = 2, 
        /** Client specified an invalid argument.  Note that this differs
     from FAILED_PRECONDITION.  INVALID_ARGUMENT indicates arguments
     that are problematic regardless of the state of the system
     (e.g., a malformed file name). */
        GRPC_STATUS_INVALID_ARGUMENT = 3, 
        /** Deadline expired before operation could complete.  For operations
     that change the state of the system, this error may be returned
     even if the operation has completed successfully.  For example, a
     successful response from a server could have been delayed long
     enough for the deadline to expire. */
        GRPC_STATUS_DEADLINE_EXCEEDED = 4, 
        /** Some requested entity (e.g., file or directory) was not found. */
        GRPC_STATUS_NOT_FOUND = 5, 
        /** Some entity that we attempted to create (e.g., file or directory)
     already exists. */
        GRPC_STATUS_ALREADY_EXISTS = 6, 
        /** The caller does not have permission to execute the specified
     operation.  PERMISSION_DENIED must not be used for rejections
     caused by exhausting some resource (use RESOURCE_EXHAUSTED
     instead for those errors).  PERMISSION_DENIED must not be
     used if the caller can not be identified (use UNAUTHENTICATED
     instead for those errors). */
        GRPC_STATUS_PERMISSION_DENIED = 7, 
        /** The request does not have valid authentication credentials for the
     operation. */
        GRPC_STATUS_UNAUTHENTICATED = 16, 
        /** Some resource has been exhausted, perhaps a per-user quota, or
     perhaps the entire file system is out of space. */
        GRPC_STATUS_RESOURCE_EXHAUSTED = 8, 
        /** Operation was rejected because the system is not in a state
     required for the operation's execution.  For example, directory
     to be deleted may be non-empty, an rmdir operation is applied to
     a non-directory, etc.

     A litmus test that may help a service implementor in deciding
     between FAILED_PRECONDITION, ABORTED, and UNAVAILABLE:
      (a) Use UNAVAILABLE if the client can retry just the failing call.
      (b) Use ABORTED if the client should retry at a higher-level
          (e.g., restarting a read-modify-write sequence).
      (c) Use FAILED_PRECONDITION if the client should not retry until
          the system state has been explicitly fixed.  E.g., if an "rmdir"
          fails because the directory is non-empty, FAILED_PRECONDITION
          should be returned since the client should not retry unless
          they have first fixed up the directory by deleting files from it.
      (d) Use FAILED_PRECONDITION if the client performs conditional
          REST Get/Update/Delete on a resource and the resource on the
          server does not match the condition. E.g., conflicting
          read-modify-write on the same resource. */
        GRPC_STATUS_FAILED_PRECONDITION = 9, 
        /** The operation was aborted, typically due to a concurrency issue
     like sequencer check failures, transaction aborts, etc.

     See litmus test above for deciding between FAILED_PRECONDITION,
     ABORTED, and UNAVAILABLE. */
        GRPC_STATUS_ABORTED = 10, 
        /** Operation was attempted past the valid range.  E.g., seeking or
     reading past end of file.

     Unlike INVALID_ARGUMENT, this error indicates a problem that may
     be fixed if the system state changes. For example, a 32-bit file
     system will generate INVALID_ARGUMENT if asked to read at an
     offset that is not in the range [0,2^32-1], but it will generate
     OUT_OF_RANGE if asked to read from an offset past the current
     file size.

     There is a fair bit of overlap between FAILED_PRECONDITION and
     OUT_OF_RANGE.  We recommend using OUT_OF_RANGE (the more specific
     error) when it applies so that callers who are iterating through
     a space can easily look for an OUT_OF_RANGE error to detect when
     they are done. */
        GRPC_STATUS_OUT_OF_RANGE = 11, 
        /** Operation is not implemented or not supported/enabled in this service. */
        GRPC_STATUS_UNIMPLEMENTED = 12, 
        /** Internal errors.  Means some invariants expected by underlying
     system has been broken.  If you see one of these errors,
     something is very broken. */
        GRPC_STATUS_INTERNAL = 13, 
        /** The service is currently unavailable.  This is a most likely a
     transient condition and may be corrected by retrying with
     a backoff. Note that it is not always safe to retry non-idempotent
     operations.

     WARNING: Although data MIGHT not have been transmitted when this
     status occurs, there is NOT A GUARANTEE that the server has not seen
     anything. So in general it is unsafe to retry on this status code
     if the call is non-idempotent.

     See litmus test above for deciding between FAILED_PRECONDITION,
     ABORTED, and UNAVAILABLE. */
        GRPC_STATUS_UNAVAILABLE = 14, 
        /** Unrecoverable data loss or corruption. */
        GRPC_STATUS_DATA_LOSS = 15, 
        /** Force users to include a default branch: */
        GRPC_STATUS__DO_NOT_USE = -1, 
    }
    enum GRPC_STATUS_OK = grpc_status_code.GRPC_STATUS_OK;
    enum GRPC_STATUS_CANCELLED = grpc_status_code.GRPC_STATUS_CANCELLED;
    enum GRPC_STATUS_UNKNOWN = grpc_status_code.GRPC_STATUS_UNKNOWN;
    enum GRPC_STATUS_INVALID_ARGUMENT = grpc_status_code.GRPC_STATUS_INVALID_ARGUMENT;
    enum GRPC_STATUS_DEADLINE_EXCEEDED = grpc_status_code.GRPC_STATUS_DEADLINE_EXCEEDED;
    enum GRPC_STATUS_NOT_FOUND = grpc_status_code.GRPC_STATUS_NOT_FOUND;
    enum GRPC_STATUS_ALREADY_EXISTS = grpc_status_code.GRPC_STATUS_ALREADY_EXISTS;
    enum GRPC_STATUS_PERMISSION_DENIED = grpc_status_code.GRPC_STATUS_PERMISSION_DENIED;
    enum GRPC_STATUS_UNAUTHENTICATED = grpc_status_code.GRPC_STATUS_UNAUTHENTICATED;
    enum GRPC_STATUS_RESOURCE_EXHAUSTED = grpc_status_code.GRPC_STATUS_RESOURCE_EXHAUSTED;
    enum GRPC_STATUS_FAILED_PRECONDITION = grpc_status_code.GRPC_STATUS_FAILED_PRECONDITION;
    enum GRPC_STATUS_ABORTED = grpc_status_code.GRPC_STATUS_ABORTED;
    enum GRPC_STATUS_OUT_OF_RANGE = grpc_status_code.GRPC_STATUS_OUT_OF_RANGE;
    enum GRPC_STATUS_UNIMPLEMENTED = grpc_status_code.GRPC_STATUS_UNIMPLEMENTED;
    enum GRPC_STATUS_INTERNAL = grpc_status_code.GRPC_STATUS_INTERNAL;
    enum GRPC_STATUS_UNAVAILABLE = grpc_status_code.GRPC_STATUS_UNAVAILABLE;
    enum GRPC_STATUS_DATA_LOSS = grpc_status_code.GRPC_STATUS_DATA_LOSS;
    enum GRPC_STATUS__DO_NOT_USE = grpc_status_code.GRPC_STATUS__DO_NOT_USE;
    /** undo the above with (a possibly different) \a slice */
    void grpc_slice_buffer_undo_take_first(grpc_slice_buffer*, grpc_slice) @nogc nothrow;
    /** take the first slice in the slice buffer */
    grpc_slice grpc_slice_buffer_take_first(grpc_slice_buffer*) @nogc nothrow;
    /** move the first n bytes of src into dst (copying them) */
    void grpc_slice_buffer_move_first_into_buffer(grpc_slice_buffer*, size_t, void*) @nogc nothrow;
    /** move the first n bytes of src into dst without adding references */
    void grpc_slice_buffer_move_first_no_ref(grpc_slice_buffer*, size_t, grpc_slice_buffer*) @nogc nothrow;
    /** move the first n bytes of src into dst */
    void grpc_slice_buffer_move_first(grpc_slice_buffer*, size_t, grpc_slice_buffer*) @nogc nothrow;
    /** remove n bytes from the end of a slice buffer */
    void grpc_slice_buffer_trim_end(grpc_slice_buffer*, size_t, grpc_slice_buffer*) @nogc nothrow;
    /** move all of the elements of src into dst */
    void grpc_slice_buffer_move_into(grpc_slice_buffer*, grpc_slice_buffer*) @nogc nothrow;
    /** swap the contents of two slice buffers */
    void grpc_slice_buffer_swap(grpc_slice_buffer*, grpc_slice_buffer*) @nogc nothrow;
    /** clear a slice buffer, unref all elements */
    void grpc_slice_buffer_reset_and_unref(grpc_slice_buffer*) @nogc nothrow;
    /** pop the last buffer, but don't unref it */
    void grpc_slice_buffer_pop(grpc_slice_buffer*) @nogc nothrow;
    /** add a very small (less than 8 bytes) amount of data to the end of a slice
   buffer: returns a pointer into which to add the data */
    uint8_t* grpc_slice_buffer_tiny_add(grpc_slice_buffer*, size_t) @nogc nothrow;
    
    void grpc_slice_buffer_addn(grpc_slice_buffer*, grpc_slice*, size_t) @nogc nothrow;
    /** add an element to a slice buffer - takes ownership of the slice and returns
   the index of the slice.
   Guarantees that the slice will not be concatenated at the end of another
   slice (i.e. the data for this slice will begin at the first byte of the
   slice at the returned index in sb->slices)
   The implementation MAY decide to concatenate data at the end of a small
   slice added in this fashion. */
    size_t grpc_slice_buffer_add_indexed(grpc_slice_buffer*, grpc_slice) @nogc nothrow;
    /** Add an element to a slice buffer - takes ownership of the slice.
   This function is allowed to concatenate the passed in slice to the end of
   some other slice if desired by the slice buffer. */
    void grpc_slice_buffer_add(grpc_slice_buffer*, grpc_slice) @nogc nothrow;
    /** destroy a slice buffer - unrefs any held elements */
    void grpc_slice_buffer_destroy(grpc_slice_buffer*) @nogc nothrow;
    /** initialize a slice buffer */
    void grpc_slice_buffer_init(grpc_slice_buffer*) @nogc nothrow;
    /** Return a copy of slice as a C string. Offers no protection against embedded
   NULL's. Returned string must be freed with gpr_free. */
    char* grpc_slice_to_c_string(grpc_slice) @nogc nothrow;
    /** Return a slice pointing to newly allocated memory that has the same contents
 * as \a s */
    grpc_slice grpc_slice_dup(grpc_slice) @nogc nothrow;
    /** Do two slices point at the same memory, with the same length
   If a or b is inlined, actually compares data */
    int grpc_slice_is_equivalent(grpc_slice, grpc_slice) @nogc nothrow;
    /** return the index of the first occurrence of \a needle in \a haystack, or -1
   if it's not found */
    int grpc_slice_slice(grpc_slice, grpc_slice) @nogc nothrow;
    
    int grpc_slice_chr(grpc_slice, char) @nogc nothrow;
    /** return the index of the last instance of \a c in \a s, or -1 if not found */
    int grpc_slice_rchr(grpc_slice, char) @nogc nothrow;
    /** return non-zero if the first blen bytes of a are equal to b */
    int grpc_slice_buf_start_eq(grpc_slice, const(void)*, size_t) @nogc nothrow;
    
    int grpc_slice_str_cmp(grpc_slice, const(char)*) @nogc nothrow;
    /** Returns <0 if a < b, ==0 if a == b, >0 if a > b
   The order is arbitrary, and is not guaranteed to be stable across different
   versions of the API. */
    int grpc_slice_cmp(grpc_slice, grpc_slice) @nogc nothrow;
    
    int grpc_slice_eq(grpc_slice, grpc_slice) @nogc nothrow;
    
    grpc_slice grpc_empty_slice() @nogc nothrow;
    /** Splits s into two: modifies s to be s[split:s.length], and returns a new
   slice, sharing a refcount with s, that contains s[0:split].
   Requires s initialized, split <= s.length */
    grpc_slice grpc_slice_split_head(grpc_slice*, size_t) @nogc nothrow;
    /** The same as grpc_slice_split_tail, but with an option to skip altering
 * refcounts (grpc_slice_split_tail_maybe_ref(..., true) is equivalent to
 * grpc_slice_split_tail(...)) */
    grpc_slice grpc_slice_split_tail_maybe_ref(grpc_slice*, size_t, grpc_slice_ref_whom) @nogc nothrow;
    
    enum grpc_slice_ref_whom
    {
        
        GRPC_SLICE_REF_TAIL = 1, 
        
        GRPC_SLICE_REF_HEAD = 2, 
        
        GRPC_SLICE_REF_BOTH = 3, 
    }
    enum GRPC_SLICE_REF_TAIL = grpc_slice_ref_whom.GRPC_SLICE_REF_TAIL;
    enum GRPC_SLICE_REF_HEAD = grpc_slice_ref_whom.GRPC_SLICE_REF_HEAD;
    enum GRPC_SLICE_REF_BOTH = grpc_slice_ref_whom.GRPC_SLICE_REF_BOTH;
    /** Splits s into two: modifies s to be s[0:split], and returns a new slice,
   sharing a refcount with s, that contains s[split:s.length].
   Requires s initialized, split <= s.length */
    grpc_slice grpc_slice_split_tail(grpc_slice*, size_t) @nogc nothrow;
    /** The same as grpc_slice_sub, but without altering the ref count */
    grpc_slice grpc_slice_sub_no_ref(grpc_slice, size_t, size_t) @nogc nothrow;
    /** Return a result slice derived from s, which shares a ref count with \a s,
   where result.data==s.data+begin, and result.length==end-begin. The ref count
   of \a s is increased by one. Do not assign result back to \a s.
   Requires s initialized, begin <= end, begin <= s.length, and
   end <= source->length. */
    grpc_slice grpc_slice_sub(grpc_slice, size_t, size_t) @nogc nothrow;
    /** Create a slice pointing to constant memory */
    grpc_slice grpc_slice_from_static_buffer(const(void)*, size_t) @nogc nothrow;
    /** Create a slice pointing to constant memory */
    grpc_slice grpc_slice_from_static_string(const(char)*) @nogc nothrow;
    /** Create a slice by copying a buffer.
   Equivalent to:
     grpc_slice slice = grpc_slice_malloc(len);
     memcpy(slice->data, source, len); */
    grpc_slice grpc_slice_from_copied_buffer(const(char)*, size_t) @nogc nothrow;
    /** Create a slice by copying a string.
   Does not preserve null terminators.
   Equivalent to:
     size_t len = strlen(source);
     grpc_slice slice = grpc_slice_malloc(len);
     memcpy(slice->data, source, len); */
    grpc_slice grpc_slice_from_copied_string(const(char)*) @nogc nothrow;
    
    grpc_slice grpc_slice_malloc_large(size_t) @nogc nothrow;
    /** Equivalent to grpc_slice_new(malloc(len), len, free), but saves one malloc()
   call.
   Aborts if malloc() fails. */
    grpc_slice grpc_slice_malloc(size_t) @nogc nothrow;
    /** Equivalent to grpc_slice_new, but with a two argument destroy function that
   also takes the slice length. */
    grpc_slice grpc_slice_new_with_len(void*, size_t, void function(void*, size_t)) @nogc nothrow;
    /** Equivalent to grpc_slice_new, but with a separate pointer that is
   passed to the destroy function.  This function can be useful when
   the data is part of a larger structure that must be destroyed when
   the data is no longer needed. */
    grpc_slice grpc_slice_new_with_user_data(void*, size_t, void function(void*), void*) @nogc nothrow;
    /** Create a slice pointing at some data. Calls malloc to allocate a refcount
   for the object, and arranges that destroy will be called with the pointer
   passed in at destruction. */
    grpc_slice grpc_slice_new(void*, size_t, void function(void*)) @nogc nothrow;
    /** Copy slice - create a new slice that contains the same data as s */
    grpc_slice grpc_slice_copy(grpc_slice) @nogc nothrow;
    /** Decrement the ref count of s.  If the ref count of s reaches zero, all
   slices sharing the ref count are destroyed, and considered no longer
   initialized.  If s is ultimately derived from a call to grpc_slice_new(start,
   len, dest) where dest!=NULL , then (*dest)(start) is called, else if s is
   ultimately derived from a call to grpc_slice_new_with_len(start, len, dest)
   where dest!=NULL , then (*dest)(start, len).  Requires s initialized.  */
    void grpc_slice_unref(grpc_slice) @nogc nothrow;
    /** Increment the refcount of s. Requires slice is initialized.
   Returns s. */
    grpc_slice grpc_slice_ref(grpc_slice) @nogc nothrow;
    /** Represents an expandable array of slices, to be interpreted as a
   single item. */
    struct grpc_slice_buffer
    {
        /** This is for internal use only. External users (i.e any code outside grpc
   * core) MUST NOT use this field */
        grpc_slice* base_slices;
        /** slices in the array (Points to the first valid grpc_slice in the array) */
        grpc_slice* slices;
        /** the number of slices in the array */
        size_t count;
        /** the number of slices allocated in the array. External users (i.e any code
   * outside grpc core) MUST NOT use this field */
        size_t capacity;
        /** the combined length of all slices in the array */
        size_t length;
        /** inlined elements to avoid allocations */
        grpc_slice[8] inlined;
    }
    struct grpc_slice_refcount;
    /** A grpc_slice s, if initialized, represents the byte range
   s.bytes[0..s.length-1].

   It can have an associated ref count which has a destruction routine to be run
   when the ref count reaches zero (see grpc_slice_new() and grp_slice_unref()).
   Multiple grpc_slice values may share a ref count.

   If the slice does not have a refcount, it represents an inlined small piece
   of data that is copied by value.

   As a special case, a slice can be given refcount == uintptr_t(1), meaning
   that the slice represents external data that is not refcounted. */
    struct grpc_slice
    {
        
        grpc_slice_refcount* refcount;
        
        union grpc_slice_data
        {
            
            struct grpc_slice_refcounted
            {
                
                size_t length;
                
                uint8_t* bytes;
            }
            
            grpc_slice_refcounted refcounted;
            
            struct grpc_slice_inlined
            {
                
                uint8_t length;
                
                uint8_t[23] bytes;
            }
            
            grpc_slice.grpc_slice_data.grpc_slice_inlined inlined;
        }
        
        grpc_slice.grpc_slice_data data;
    }
    struct grpc_completion_queue_factory;
    
    struct grpc_completion_queue_attributes
    {
        /** The version number of this structure. More fields might be added to this
     structure in future. */
        int version_;
        /** Set to GRPC_CQ_CURRENT_VERSION */
        grpc_cq_completion_type cq_completion_type;
        
        grpc_cq_polling_type cq_polling_type;
        /** When creating a callbackable CQ, pass in a functor to get invoked when
   * shutdown is complete */
        grpc_completion_queue_functor* cq_shutdown_cb;
    }
    /** Specifies an interface class to be used as a tag for callback-based
 * completion queues. This can be used directly, as the first element of a
 * struct in C, or as a base class in C++. Its "run" value should be assigned to
 * some non-member function, such as a static method. */
    struct grpc_completion_queue_functor
    {
        /** The run member specifies a function that will be called when this
      tag is extracted from the completion queue. Its arguments will be a
      pointer to this functor and a boolean that indicates whether the
      operation succeeded (non-zero) or failed (zero) */
        void function(grpc_completion_queue_functor*, int) functor_run;
        /** The inlineable member specifies whether this functor can be run inline.
      This should only be used for trivial internally-defined functors. */
        int inlineable;
        /** The following fields are not API. They are meant for internal use. */
        int internal_success;
        
        grpc_completion_queue_functor* internal_next;
    }
    /** Specifies the type of APIs to use to pop events from the completion queue */
    enum grpc_cq_completion_type
    {
        /** Events are popped out by calling grpc_completion_queue_next() API ONLY */
        GRPC_CQ_NEXT = 0, 
        /** Events are popped out by calling grpc_completion_queue_pluck() API ONLY*/
        GRPC_CQ_PLUCK = 1, 
        /** Events trigger a callback specified as the tag */
        GRPC_CQ_CALLBACK = 2, 
    }
    enum GRPC_CQ_NEXT = grpc_cq_completion_type.GRPC_CQ_NEXT;
    enum GRPC_CQ_PLUCK = grpc_cq_completion_type.GRPC_CQ_PLUCK;
    enum GRPC_CQ_CALLBACK = grpc_cq_completion_type.GRPC_CQ_CALLBACK;
    /** Completion queues internally MAY maintain a set of file descriptors in a
    structure called 'pollset'. This enum specifies if a completion queue has an
    associated pollset and any restrictions on the type of file descriptors that
    can be present in the pollset.

    I/O progress can only be made when grpc_completion_queue_next() or
    grpc_completion_queue_pluck() are called on the completion queue (unless the
    grpc_cq_polling_type is GRPC_CQ_NON_POLLING) and hence it is very important
    to actively call these APIs */
    enum grpc_cq_polling_type
    {
        /** The completion queue will have an associated pollset and there is no
      restriction on the type of file descriptors the pollset may contain */
        GRPC_CQ_DEFAULT_POLLING = 0, 
        /** Similar to GRPC_CQ_DEFAULT_POLLING except that the completion queues will
      not contain any 'listening file descriptors' (i.e file descriptors used to
      listen to incoming channels) */
        GRPC_CQ_NON_LISTENING = 1, 
        /** The completion queue will not have an associated pollset. Note that
      grpc_completion_queue_next() or grpc_completion_queue_pluck() MUST still
      be called to pop events from the completion queue; it is not required to
      call them actively to make I/O progress */
        GRPC_CQ_NON_POLLING = 2, 
    }
    enum GRPC_CQ_DEFAULT_POLLING = grpc_cq_polling_type.GRPC_CQ_DEFAULT_POLLING;
    enum GRPC_CQ_NON_LISTENING = grpc_cq_polling_type.GRPC_CQ_NON_LISTENING;
    enum GRPC_CQ_NON_POLLING = grpc_cq_polling_type.GRPC_CQ_NON_POLLING;
    struct grpc_resource_quota;
    /** Information requested from the channel. */
    struct grpc_channel_info
    {
        /** If non-NULL, will be set to point to a string indicating the LB
   * policy name.  Caller takes ownership. */
        char** lb_policy_name;
        /** If non-NULL, will be set to point to a string containing the
   * service config used by the channel in JSON form. */
        char** service_config_json;
    }
    /** Operation data: one field for each op type (except SEND_CLOSE_FROM_CLIENT
   which has no arguments) */
    struct grpc_op
    {
        /** Operation type, as defined by grpc_op_type */
        grpc_op_type op;
        /** Write flags bitset for grpc_begin_messages */
        uint32_t flags;
        /** Reserved for future usage */
        void* reserved;
        
        union grpc_op_data
        {
            /** Reserved for future usage */
            static struct _Anonymous_0
            {
                
                void*[8] reserved;
            }
            
            _Anonymous_0 reserved;
            
            struct grpc_op_send_initial_metadata
            {
                
                size_t count;
                
                grpc_metadata* metadata;
                /** If \a is_set, \a compression_level will be used for the call.
       * Otherwise, \a compression_level won't be considered */
                struct grpc_op_send_initial_metadata_maybe_compression_level
                {
                    
                    uint8_t is_set;
                    
                    grpc_compression_level level;
                }
                
                grpc_op.grpc_op_data.grpc_op_send_initial_metadata.grpc_op_send_initial_metadata_maybe_compression_level maybe_compression_level;
            }
            
            grpc_op.grpc_op_data.grpc_op_send_initial_metadata send_initial_metadata;
            
            struct grpc_op_send_message
            {
                /** This op takes ownership of the slices in send_message.  After
       * a call completes, the contents of send_message are not guaranteed
       * and likely empty.  The original owner should still call
       * grpc_byte_buffer_destroy() on this object however.
       */
                grpc_byte_buffer* send_message;
            }
            
            grpc_op.grpc_op_data.grpc_op_send_message send_message;
            
            struct grpc_op_send_status_from_server
            {
                
                size_t trailing_metadata_count;
                
                grpc_metadata* trailing_metadata;
                
                grpc_status_code status;
                /** optional: set to NULL if no details need sending, non-NULL if they do
       * pointer will not be retained past the start_batch call
       */
                grpc_slice* status_details;
            }
            
            grpc_op.grpc_op_data.grpc_op_send_status_from_server send_status_from_server;
            /** ownership of the array is with the caller, but ownership of the elements
        stays with the call object (ie key, value members are owned by the call
        object, recv_initial_metadata->array is owned by the caller).
        After the operation completes, call grpc_metadata_array_destroy on this
        value, or reuse it in a future op. */
            struct grpc_op_recv_initial_metadata
            {
                
                grpc_metadata_array* recv_initial_metadata;
            }
            
            grpc_op.grpc_op_data.grpc_op_recv_initial_metadata recv_initial_metadata;
            /** ownership of the byte buffer is moved to the caller; the caller must
        call grpc_byte_buffer_destroy on this value, or reuse it in a future op.
        The returned byte buffer will be NULL if trailing metadata was
        received instead of a message.
       */
            struct grpc_op_recv_message
            {
                
                grpc_byte_buffer** recv_message;
            }
            
            grpc_op.grpc_op_data.grpc_op_recv_message recv_message;
            
            struct grpc_op_recv_status_on_client
            {
                /** ownership of the array is with the caller, but ownership of the
          elements stays with the call object (ie key, value members are owned
          by the call object, trailing_metadata->array is owned by the caller).
          After the operation completes, call grpc_metadata_array_destroy on
          this value, or reuse it in a future op. */
                grpc_metadata_array* trailing_metadata;
                
                grpc_status_code* status;
                
                grpc_slice* status_details;
                /** If this is not nullptr, it will be populated with the full fidelity
       * error string for debugging purposes. The application is responsible
       * for freeing the data by using gpr_free(). */
                const(char)** error_string;
            }
            
            grpc_op.grpc_op_data.grpc_op_recv_status_on_client recv_status_on_client;
            
            struct grpc_op_recv_close_on_server
            {
                /** out argument, set to 1 if the call failed at the server for
          a reason other than a non-OK status (cancel, deadline
          exceeded, network failure, etc.), 0 otherwise (RPC processing ran to
          completion and was able to provide any status from the server) */
                int* cancelled;
            }
            
            grpc_op.grpc_op_data.grpc_op_recv_close_on_server recv_close_on_server;
        }
        
        grpc_op.grpc_op_data data;
    }
    
    enum grpc_op_type
    {
        /** Send initial metadata: one and only one instance MUST be sent for each
      call, unless the call was cancelled - in which case this can be skipped.
      This op completes after all bytes of metadata have been accepted by
      outgoing flow control. */
        GRPC_OP_SEND_INITIAL_METADATA = 0, 
        /** Send a message: 0 or more of these operations can occur for each call.
      This op completes after all bytes for the message have been accepted by
      outgoing flow control. */
        GRPC_OP_SEND_MESSAGE = 1, 
        /** Send a close from the client: one and only one instance MUST be sent from
      the client, unless the call was cancelled - in which case this can be
      skipped. This op completes after all bytes for the call
      (including the close) have passed outgoing flow control. */
        GRPC_OP_SEND_CLOSE_FROM_CLIENT = 2, 
        /** Send status from the server: one and only one instance MUST be sent from
      the server unless the call was cancelled - in which case this can be
      skipped. This op completes after all bytes for the call
      (including the status) have passed outgoing flow control. */
        GRPC_OP_SEND_STATUS_FROM_SERVER = 3, 
        /** Receive initial metadata: one and only one MUST be made on the client,
      must not be made on the server.
      This op completes after all initial metadata has been read from the
      peer. */
        GRPC_OP_RECV_INITIAL_METADATA = 4, 
        /** Receive a message: 0 or more of these operations can occur for each call.
      This op completes after all bytes of the received message have been
      read, or after a half-close has been received on this call. */
        GRPC_OP_RECV_MESSAGE = 5, 
        /** Receive status on the client: one and only one must be made on the client.
      This operation always succeeds, meaning ops paired with this operation
      will also appear to succeed, even though they may not have. In that case
      the status will indicate some failure.
      This op completes after all activity on the call has completed. */
        GRPC_OP_RECV_STATUS_ON_CLIENT = 6, 
        /** Receive close on the server: one and only one must be made on the
      server. This op completes after the close has been received by the
      server. This operation always succeeds, meaning ops paired with
      this operation will also appear to succeed, even though they may not
      have. */
        GRPC_OP_RECV_CLOSE_ON_SERVER = 7, 
    }
    enum GRPC_OP_SEND_INITIAL_METADATA = grpc_op_type.GRPC_OP_SEND_INITIAL_METADATA;
    enum GRPC_OP_SEND_MESSAGE = grpc_op_type.GRPC_OP_SEND_MESSAGE;
    enum GRPC_OP_SEND_CLOSE_FROM_CLIENT = grpc_op_type.GRPC_OP_SEND_CLOSE_FROM_CLIENT;
    enum GRPC_OP_SEND_STATUS_FROM_SERVER = grpc_op_type.GRPC_OP_SEND_STATUS_FROM_SERVER;
    enum GRPC_OP_RECV_INITIAL_METADATA = grpc_op_type.GRPC_OP_RECV_INITIAL_METADATA;
    enum GRPC_OP_RECV_MESSAGE = grpc_op_type.GRPC_OP_RECV_MESSAGE;
    enum GRPC_OP_RECV_STATUS_ON_CLIENT = grpc_op_type.GRPC_OP_RECV_STATUS_ON_CLIENT;
    enum GRPC_OP_RECV_CLOSE_ON_SERVER = grpc_op_type.GRPC_OP_RECV_CLOSE_ON_SERVER;
    
    struct grpc_call_details
    {
        
        grpc_slice method;
        
        grpc_slice host;
        
        gpr_timespec deadline;
    }
    
    struct grpc_metadata_array
    {
        
        size_t count;
        
        size_t capacity;
        
        grpc_metadata* metadata;
    }
    /** The result of an operation.

    Returned by a completion queue when the operation started with tag. */
    struct grpc_event
    {
        /** The type of the completion. */
        grpc_completion_type type;
        /** If the grpc_completion_type is GRPC_OP_COMPLETE, this field indicates
      whether the operation was successful or not; 0 in case of failure and
      non-zero in case of success.
      If grpc_completion_type is GRPC_QUEUE_SHUTDOWN or GRPC_QUEUE_TIMEOUT, this
      field is guaranteed to be 0 */
        int success;
        /** The tag passed to grpc_call_start_batch etc to start this operation.
      *Only* GRPC_OP_COMPLETE has a tag. For all other grpc_completion_type
      values, tag is uninitialized. */
        void* tag;
    }
    /** The type of completion (for grpc_event) */
    enum grpc_completion_type
    {
        /** Shutting down */
        GRPC_QUEUE_SHUTDOWN = 0, 
        /** No event before timeout */
        GRPC_QUEUE_TIMEOUT = 1, 
        /** Operation completion */
        GRPC_OP_COMPLETE = 2, 
    }
    enum GRPC_QUEUE_SHUTDOWN = grpc_completion_type.GRPC_QUEUE_SHUTDOWN;
    enum GRPC_QUEUE_TIMEOUT = grpc_completion_type.GRPC_QUEUE_TIMEOUT;
    enum GRPC_OP_COMPLETE = grpc_completion_type.GRPC_OP_COMPLETE;
    /** A single metadata element */
    struct grpc_metadata
    {
        /** the key, value values are expected to line up with grpc_mdelem: if
     changing them, update metadata.h at the same time. */
        grpc_slice key;
        
        grpc_slice value;
        /** The following fields are reserved for grpc internal use.
      There is no need to initialize them, and they will be set to garbage
      during calls to grpc. */
        static struct _Anonymous_1
        {
            
            void*[4] obfuscated;
        }
        
        _Anonymous_1 internal_data;
    }
    /** Result of a grpc call. If the caller satisfies the prerequisites of a
    particular operation, the grpc_call_error returned will be GRPC_CALL_OK.
    Receiving any other value listed here is an indication of a bug in the
    caller. */
    enum grpc_call_error
    {
        /** everything went ok */
        GRPC_CALL_OK = 0, 
        /** something failed, we don't know what */
        GRPC_CALL_ERROR = 1, 
        /** this method is not available on the server */
        GRPC_CALL_ERROR_NOT_ON_SERVER = 2, 
        /** this method is not available on the client */
        GRPC_CALL_ERROR_NOT_ON_CLIENT = 3, 
        /** this method must be called before server_accept */
        GRPC_CALL_ERROR_ALREADY_ACCEPTED = 4, 
        /** this method must be called before invoke */
        GRPC_CALL_ERROR_ALREADY_INVOKED = 5, 
        /** this method must be called after invoke */
        GRPC_CALL_ERROR_NOT_INVOKED = 6, 
        /** this call is already finished
      (writes_done or write_status has already been called) */
        GRPC_CALL_ERROR_ALREADY_FINISHED = 7, 
        /** there is already an outstanding read/write operation on the call */
        GRPC_CALL_ERROR_TOO_MANY_OPERATIONS = 8, 
        /** the flags value was illegal for this call */
        GRPC_CALL_ERROR_INVALID_FLAGS = 9, 
        /** invalid metadata was passed to this call */
        GRPC_CALL_ERROR_INVALID_METADATA = 10, 
        /** invalid message was passed to this call */
        GRPC_CALL_ERROR_INVALID_MESSAGE = 11, 
        /** completion queue for notification has not been registered
   * with the server */
        GRPC_CALL_ERROR_NOT_SERVER_COMPLETION_QUEUE = 12, 
        /** this batch of operations leads to more operations than allowed */
        GRPC_CALL_ERROR_BATCH_TOO_BIG = 13, 
        /** payload type requested is not the type registered */
        GRPC_CALL_ERROR_PAYLOAD_TYPE_MISMATCH = 14, 
        /** completion queue has been shutdown */
        GRPC_CALL_ERROR_COMPLETION_QUEUE_SHUTDOWN = 15, 
    }
    enum GRPC_CALL_OK = grpc_call_error.GRPC_CALL_OK;
    enum GRPC_CALL_ERROR = grpc_call_error.GRPC_CALL_ERROR;
    enum GRPC_CALL_ERROR_NOT_ON_SERVER = grpc_call_error.GRPC_CALL_ERROR_NOT_ON_SERVER;
    enum GRPC_CALL_ERROR_NOT_ON_CLIENT = grpc_call_error.GRPC_CALL_ERROR_NOT_ON_CLIENT;
    enum GRPC_CALL_ERROR_ALREADY_ACCEPTED = grpc_call_error.GRPC_CALL_ERROR_ALREADY_ACCEPTED;
    enum GRPC_CALL_ERROR_ALREADY_INVOKED = grpc_call_error.GRPC_CALL_ERROR_ALREADY_INVOKED;
    enum GRPC_CALL_ERROR_NOT_INVOKED = grpc_call_error.GRPC_CALL_ERROR_NOT_INVOKED;
    enum GRPC_CALL_ERROR_ALREADY_FINISHED = grpc_call_error.GRPC_CALL_ERROR_ALREADY_FINISHED;
    enum GRPC_CALL_ERROR_TOO_MANY_OPERATIONS = grpc_call_error.GRPC_CALL_ERROR_TOO_MANY_OPERATIONS;
    enum GRPC_CALL_ERROR_INVALID_FLAGS = grpc_call_error.GRPC_CALL_ERROR_INVALID_FLAGS;
    enum GRPC_CALL_ERROR_INVALID_METADATA = grpc_call_error.GRPC_CALL_ERROR_INVALID_METADATA;
    enum GRPC_CALL_ERROR_INVALID_MESSAGE = grpc_call_error.GRPC_CALL_ERROR_INVALID_MESSAGE;
    enum GRPC_CALL_ERROR_NOT_SERVER_COMPLETION_QUEUE = grpc_call_error.GRPC_CALL_ERROR_NOT_SERVER_COMPLETION_QUEUE;
    enum GRPC_CALL_ERROR_BATCH_TOO_BIG = grpc_call_error.GRPC_CALL_ERROR_BATCH_TOO_BIG;
    enum GRPC_CALL_ERROR_PAYLOAD_TYPE_MISMATCH = grpc_call_error.GRPC_CALL_ERROR_PAYLOAD_TYPE_MISMATCH;
    enum GRPC_CALL_ERROR_COMPLETION_QUEUE_SHUTDOWN = grpc_call_error.GRPC_CALL_ERROR_COMPLETION_QUEUE_SHUTDOWN;
    /** An array of arguments that can be passed around.

    Used to set optional channel-level configuration.
    These configuration options are modelled as key-value pairs as defined
    by grpc_arg; keys are strings to allow easy backwards-compatible extension
    by arbitrary parties. All evaluation is performed at channel creation
    time (i.e. the keys and values in this structure need only live through the
    creation invocation).

    However, if one of the args has grpc_arg_type==GRPC_ARG_POINTER, then the
    grpc_arg_pointer_vtable must live until the channel args are done being
    used by core (i.e. when the object for use with which they were passed
    is destroyed).

    See the description of the \ref grpc_arg_keys "available args" for more
    details. */
    struct grpc_channel_args
    {
        
        size_t num_args;
        
        grpc_arg* args;
    }
    /** A single argument... each argument has a key and a value

    A note on naming keys:
      Keys are namespaced into groups, usually grouped by library, and are
      keys for module XYZ are named XYZ.key1, XYZ.key2, etc. Module names must
      be restricted to the regex [A-Za-z][_A-Za-z0-9]{,15}.
      Key names must be restricted to the regex [A-Za-z][_A-Za-z0-9]{,47}.

    GRPC core library keys are prefixed by grpc.

    Library authors are strongly encouraged to \#define symbolic constants for
    their keys so that it's possible to change them in the future. */
    struct grpc_arg
    {
        
        grpc_arg_type type;
        
        char* key;
        
        union grpc_arg_value
        {
            
            char* string_;
            
            int integer;
            
            struct grpc_arg_pointer
            {
                
                void* p;
                
                const(grpc_arg_pointer_vtable)* vtable;
            }
            
            grpc_arg.grpc_arg_value.grpc_arg_pointer pointer;
        }
        
        grpc_arg.grpc_arg_value value;
    }
    
    struct grpc_arg_pointer_vtable
    {
        
        void* function(void*) copy;
        
        void function(void*) destroy;
        
        int function(void*, void*) cmp;
    }
    /** Type specifier for grpc_arg */
    enum grpc_arg_type
    {
        
        GRPC_ARG_STRING = 0, 
        
        GRPC_ARG_INTEGER = 1, 
        
        GRPC_ARG_POINTER = 2, 
    }
    enum GRPC_ARG_STRING = grpc_arg_type.GRPC_ARG_STRING;
    enum GRPC_ARG_INTEGER = grpc_arg_type.GRPC_ARG_INTEGER;
    enum GRPC_ARG_POINTER = grpc_arg_type.GRPC_ARG_POINTER;
    struct grpc_socket_factory;
    struct grpc_socket_mutator;
    struct grpc_call;
    struct grpc_server;
    struct grpc_channel;
    struct grpc_completion_queue;
    
    struct grpc_byte_buffer
    {
        
        void* reserved;
        
        grpc_byte_buffer_type type;
        
        union grpc_byte_buffer_data
        {
            
            static struct _Anonymous_2
            {
                
                void*[8] reserved;
            }
            
            _Anonymous_2 reserved;
            
            struct grpc_compressed_buffer
            {
                
                grpc_compression_algorithm compression;
                
                grpc_slice_buffer slice_buffer;
            }
            
            grpc_byte_buffer.grpc_byte_buffer_data.grpc_compressed_buffer raw;
        }
        
        grpc_byte_buffer.grpc_byte_buffer_data data;
    }
    
    enum grpc_byte_buffer_type
    {
        
        GRPC_BB_RAW = 0, 
    }
    enum GRPC_BB_RAW = grpc_byte_buffer_type.GRPC_BB_RAW;
    /** Connectivity state of a channel. */
    enum grpc_connectivity_state
    {
        /** channel is idle */
        GRPC_CHANNEL_IDLE = 0, 
        /** channel is connecting */
        GRPC_CHANNEL_CONNECTING = 1, 
        /** channel is ready for work */
        GRPC_CHANNEL_READY = 2, 
        /** channel has seen a failure but expects to recover */
        GRPC_CHANNEL_TRANSIENT_FAILURE = 3, 
        /** channel has seen a failure that it cannot recover from */
        GRPC_CHANNEL_SHUTDOWN = 4, 
    }
    enum GRPC_CHANNEL_IDLE = grpc_connectivity_state.GRPC_CHANNEL_IDLE;
    enum GRPC_CHANNEL_CONNECTING = grpc_connectivity_state.GRPC_CHANNEL_CONNECTING;
    enum GRPC_CHANNEL_READY = grpc_connectivity_state.GRPC_CHANNEL_READY;
    enum GRPC_CHANNEL_TRANSIENT_FAILURE = grpc_connectivity_state.GRPC_CHANNEL_TRANSIENT_FAILURE;
    enum GRPC_CHANNEL_SHUTDOWN = grpc_connectivity_state.GRPC_CHANNEL_SHUTDOWN;
    
    struct grpc_compression_options
    {
        /** All algs are enabled by default. This option corresponds to the channel
   * argument key behind \a GRPC_COMPRESSION_CHANNEL_ENABLED_ALGORITHMS_BITSET
   */
        uint32_t enabled_algorithms_bitset;
        /** The default compression level. It'll be used in the absence of call
   * specific settings. This option corresponds to the channel
   * argument key behind \a GRPC_COMPRESSION_CHANNEL_DEFAULT_LEVEL. If present,
   * takes precedence over \a default_algorithm.
   * TODO(dgq): currently only available for server channels. */
        struct grpc_compression_options_default_level
        {
            
            int is_set;
            
            grpc_compression_level level;
        }
        
        grpc_compression_options.grpc_compression_options_default_level default_level;
        /** The default message compression algorithm. It'll be used in the absence of
   * call specific settings. This option corresponds to the channel argument key
   * behind \a GRPC_COMPRESSION_CHANNEL_DEFAULT_ALGORITHM. */
        struct grpc_compression_options_default_algorithm
        {
            
            int is_set;
            
            grpc_compression_algorithm algorithm;
        }
        
        grpc_compression_options.grpc_compression_options_default_algorithm default_algorithm;
    }
    /** Compression levels allow a party with knowledge of its peer's accepted
 * encodings to request compression in an abstract way. The level-algorithm
 * mapping is performed internally and depends on the peer's supported
 * compression algorithms. */
    enum grpc_compression_level
    {
        
        GRPC_COMPRESS_LEVEL_NONE = 0, 
        
        GRPC_COMPRESS_LEVEL_LOW = 1, 
        
        GRPC_COMPRESS_LEVEL_MED = 2, 
        
        GRPC_COMPRESS_LEVEL_HIGH = 3, 
        
        GRPC_COMPRESS_LEVEL_COUNT = 4, 
    }
    enum GRPC_COMPRESS_LEVEL_NONE = grpc_compression_level.GRPC_COMPRESS_LEVEL_NONE;
    enum GRPC_COMPRESS_LEVEL_LOW = grpc_compression_level.GRPC_COMPRESS_LEVEL_LOW;
    enum GRPC_COMPRESS_LEVEL_MED = grpc_compression_level.GRPC_COMPRESS_LEVEL_MED;
    enum GRPC_COMPRESS_LEVEL_HIGH = grpc_compression_level.GRPC_COMPRESS_LEVEL_HIGH;
    enum GRPC_COMPRESS_LEVEL_COUNT = grpc_compression_level.GRPC_COMPRESS_LEVEL_COUNT;
    /** The various compression algorithms supported by gRPC (not sorted by
 * compression level) */
    enum grpc_compression_algorithm
    {
        
        GRPC_COMPRESS_NONE = 0, 
        
        GRPC_COMPRESS_DEFLATE = 1, 
        
        GRPC_COMPRESS_GZIP = 2, 
        
        GRPC_COMPRESS_ALGORITHMS_COUNT = 3, 
    }
    enum GRPC_COMPRESS_NONE = grpc_compression_algorithm.GRPC_COMPRESS_NONE;
    enum GRPC_COMPRESS_DEFLATE = grpc_compression_algorithm.GRPC_COMPRESS_DEFLATE;
    enum GRPC_COMPRESS_GZIP = grpc_compression_algorithm.GRPC_COMPRESS_GZIP;
    enum GRPC_COMPRESS_ALGORITHMS_COUNT = grpc_compression_algorithm.GRPC_COMPRESS_ALGORITHMS_COUNT;
    /** The TLS versions that are supported by the SSL stack. **/
    enum grpc_tls_version
    {
        
        TLS1_2 = 0, 
        
        TLS1_3 = 1, 
    }
    enum TLS1_2 = grpc_tls_version.TLS1_2;
    enum TLS1_3 = grpc_tls_version.TLS1_3;
    /**
 * Type of local connections for which local channel/server credentials will be
 * applied. It supports UDS and local TCP connections.
 */
    enum grpc_local_connect_type
    {
        
        UDS = 0, 
        
        LOCAL_TCP = 1, 
    }
    enum UDS = grpc_local_connect_type.UDS;
    enum LOCAL_TCP = grpc_local_connect_type.LOCAL_TCP;
    
    enum grpc_security_level
    {
        
        GRPC_SECURITY_MIN = 0, 
        
        GRPC_SECURITY_NONE = 0, 
        
        GRPC_INTEGRITY_ONLY = 1, 
        
        GRPC_PRIVACY_AND_INTEGRITY = 2, 
        
        GRPC_SECURITY_MAX = 2, 
    }
    enum GRPC_SECURITY_MIN = grpc_security_level.GRPC_SECURITY_MIN;
    enum GRPC_SECURITY_NONE = grpc_security_level.GRPC_SECURITY_NONE;
    enum GRPC_INTEGRITY_ONLY = grpc_security_level.GRPC_INTEGRITY_ONLY;
    enum GRPC_PRIVACY_AND_INTEGRITY = grpc_security_level.GRPC_PRIVACY_AND_INTEGRITY;
    enum GRPC_SECURITY_MAX = grpc_security_level.GRPC_SECURITY_MAX;
    
    enum grpc_ssl_client_certificate_request_type
    {
        /** Server does not request client certificate.
     The certificate presented by the client is not checked by the server at
     all. (A client may present a self signed or signed certificate or not
     present a certificate at all and any of those option would be accepted) */
        GRPC_SSL_DONT_REQUEST_CLIENT_CERTIFICATE = 0, 
        /** Server requests client certificate but does not enforce that the client
     presents a certificate.

     If the client presents a certificate, the client authentication is left to
     the application (the necessary metadata will be available to the
     application via authentication context properties, see grpc_auth_context).

     The client's key certificate pair must be valid for the SSL connection to
     be established. */
        GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_BUT_DONT_VERIFY = 1, 
        /** Server requests client certificate but does not enforce that the client
     presents a certificate.

     If the client presents a certificate, the client authentication is done by
     the gRPC framework. (For a successful connection the client needs to either
     present a certificate that can be verified against the root certificate
     configured by the server or not present a certificate at all)

     The client's key certificate pair must be valid for the SSL connection to
     be established. */
        GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_AND_VERIFY = 2, 
        /** Server requests client certificate and enforces that the client presents a
     certificate.

     If the client presents a certificate, the client authentication is left to
     the application (the necessary metadata will be available to the
     application via authentication context properties, see grpc_auth_context).

     The client's key certificate pair must be valid for the SSL connection to
     be established. */
        GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_BUT_DONT_VERIFY = 3, 
        /** Server requests client certificate and enforces that the client presents a
     certificate.

     The certificate presented by the client is verified by the gRPC framework.
     (For a successful connection the client needs to present a certificate that
     can be verified against the root certificate configured by the server)

     The client's key certificate pair must be valid for the SSL connection to
     be established. */
        GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_AND_VERIFY = 4, 
    }
    enum GRPC_SSL_DONT_REQUEST_CLIENT_CERTIFICATE = grpc_ssl_client_certificate_request_type.GRPC_SSL_DONT_REQUEST_CLIENT_CERTIFICATE;
    enum GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_BUT_DONT_VERIFY = grpc_ssl_client_certificate_request_type.GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_BUT_DONT_VERIFY;
    enum GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_AND_VERIFY = grpc_ssl_client_certificate_request_type.GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_AND_VERIFY;
    enum GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_BUT_DONT_VERIFY = grpc_ssl_client_certificate_request_type.GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_BUT_DONT_VERIFY;
    enum GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_AND_VERIFY = grpc_ssl_client_certificate_request_type.GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_AND_VERIFY;
    /** Callback results for dynamically loading a SSL certificate config. */
    enum grpc_ssl_certificate_config_reload_status
    {
        
        GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_UNCHANGED = 0, 
        
        GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_NEW = 1, 
        
        GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_FAIL = 2, 
    }
    enum GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_UNCHANGED = grpc_ssl_certificate_config_reload_status.GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_UNCHANGED;
    enum GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_NEW = grpc_ssl_certificate_config_reload_status.GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_NEW;
    enum GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_FAIL = grpc_ssl_certificate_config_reload_status.GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_FAIL;
    /** Results for the SSL roots override callback. */
    enum grpc_ssl_roots_override_result
    {
        
        GRPC_SSL_ROOTS_OVERRIDE_OK = 0, 
        
        GRPC_SSL_ROOTS_OVERRIDE_FAIL_PERMANENTLY = 1, 
        /** Do not try fallback options. */
        GRPC_SSL_ROOTS_OVERRIDE_FAIL = 2, 
    }
    enum GRPC_SSL_ROOTS_OVERRIDE_OK = grpc_ssl_roots_override_result.GRPC_SSL_ROOTS_OVERRIDE_OK;
    enum GRPC_SSL_ROOTS_OVERRIDE_FAIL_PERMANENTLY = grpc_ssl_roots_override_result.GRPC_SSL_ROOTS_OVERRIDE_FAIL_PERMANENTLY;
    enum GRPC_SSL_ROOTS_OVERRIDE_FAIL = grpc_ssl_roots_override_result.GRPC_SSL_ROOTS_OVERRIDE_FAIL;
    /**
 * EXPERIMENTAL API - Subject to change.
 * Configures a grpc_tls_credentials_options object with tls session key
 * logging capability. TLS channels using these credentials have tls session
 * key logging enabled.
 * - options is the grpc_tls_credentials_options object
 * - path is a string pointing to the location where TLS session keys would be
 *   stored.
 */
    void grpc_tls_credentials_options_set_tls_session_key_log_file_path(grpc_tls_credentials_options*, const(char)*) @nogc nothrow;
    /**
 * EXPERIMENTAL - Subject to change.
 * Releases grpc_authorization_policy_provider object. The creator of
 * grpc_authorization_policy_provider is responsible for its release.
 */
    void grpc_authorization_policy_provider_release(grpc_authorization_policy_provider*) @nogc nothrow;
    /**
 * EXPERIMENTAL - Subject to change.
 * Creates a grpc_authorization_policy_provider by watching for gRPC
 * authorization policy changes in filesystem.
 * - authz_policy is the file path of gRPC authorization policy.
 * - refresh_interval_sec is the amount of time the internal thread would wait
 *   before checking for file updates.
 * - code is the error status code on failure. On success, it equals
 *   GRPC_STATUS_OK.
 * - error_details contains details about the error if any. If the
 *   initialization is successful, it will be null. Caller must use gpr_free to
 *   destroy this string.
 */
    grpc_authorization_policy_provider* grpc_authorization_policy_provider_file_watcher_create(const(char)*, uint, grpc_status_code*, const(char)**) @nogc nothrow;
    /**
 * EXPERIMENTAL - Subject to change.
 * Creates a grpc_authorization_policy_provider using gRPC authorization policy
 * from static string.
 * - authz_policy is the input gRPC authorization policy.
 * - code is the error status code on failure. On success, it equals
 *   GRPC_STATUS_OK.
 * - error_details contains details about the error if any. If the
 *   initialization is successful, it will be null. Caller must use gpr_free to
 *   destroy this string.
 */
    grpc_authorization_policy_provider* grpc_authorization_policy_provider_static_data_create(const(char)*, grpc_status_code*, const(char)**) @nogc nothrow;
    struct grpc_authorization_policy_provider;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * This method creates an xDS server credentials object.
 *
 * \a fallback_credentials are used if the xDS control plane does not provide
 * information on how to fetch credentials dynamically.
 *
 * Does NOT take ownership of the \a fallback_credentials. (Internally takes
 * a ref to the object.)
 */
    grpc_server_credentials* grpc_xds_server_credentials_create(grpc_server_credentials*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * This method creates an xDS channel credentials object.
 *
 * Creating a channel with credentials of this type indicates that the channel
 * should get credentials configuration from the xDS control plane.
 *
 * \a fallback_credentials are used if the channel target does not have the
 * 'xds:///' scheme or if the xDS control plane does not provide information on
 * how to fetch credentials dynamically. Does NOT take ownership of the \a
 * fallback_credentials. (Internally takes a ref to the object.)
 */
    grpc_channel_credentials* grpc_xds_credentials_create(grpc_channel_credentials*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * This method creates an insecure server credentials object.
 */
    grpc_server_credentials* grpc_insecure_server_credentials_create() @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * This method creates an insecure channel credentials object.
 */
    grpc_channel_credentials* grpc_insecure_credentials_create() @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Creates a TLS server credential object based on the
 * grpc_tls_credentials_options specified by callers. The
 * grpc_server_credentials will take the ownership of the |options|.
 */
    grpc_server_credentials* grpc_tls_server_credentials_create(grpc_tls_credentials_options*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Creates a TLS channel credential object based on the
 * grpc_tls_credentials_options specified by callers. The
 * grpc_channel_credentials will take the ownership of the |options|. The
 * security level of the resulting connection is GRPC_PRIVACY_AND_INTEGRITY.
 */
    grpc_channel_credentials* grpc_tls_credentials_create(grpc_tls_credentials_options*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Performs the cancellation logic of an internal verifier.
 * This is typically used when composing the internal verifiers as part of the
 * custom verification.
 */
    void grpc_tls_certificate_verifier_cancel(grpc_tls_certificate_verifier*, grpc_tls_custom_verification_check_request*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Performs the verification logic of an internal verifier.
 * This is typically used when composing the internal verifiers as part of the
 * custom verification.
 * If |grpc_tls_certificate_verifier_verify| returns true, inspect the
 * verification result through request->status and request->error_details.
 * Otherwise, inspect through the parameter of |callback|.
 */
    int grpc_tls_certificate_verifier_verify(grpc_tls_certificate_verifier*, grpc_tls_custom_verification_check_request*, grpc_tls_on_custom_verification_check_done_cb, void*, grpc_status_code*, char**) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Sets the options of whether to check the hostname of the peer on a per-call
 * basis. This is usually used in a combination with virtual hosting at the
 * client side, where each individual call on a channel can have a different
 * host associated with it.
 * This check is intended to verify that the host specified for the individual
 * call is covered by the cert that the peer presented.
 * The default is a non-zero value, which indicates performing such checks.
 */
    void grpc_tls_credentials_options_set_check_call_host(grpc_tls_credentials_options*, int) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Sets the verifier in options. The |options| will implicitly take a new ref to
 * the |verifier|. If not set on the client side, we will verify server's
 * certificates, and check the default hostname. If not set on the server side,
 * we will verify client's certificates.
 */
    void grpc_tls_credentials_options_set_certificate_verifier(grpc_tls_credentials_options*, grpc_tls_certificate_verifier*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Releases a grpc_tls_certificate_verifier object. The creator of the
 * grpc_tls_certificate_verifier object is responsible for its release.
 */
    void grpc_tls_certificate_verifier_release(grpc_tls_certificate_verifier*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Factory function for an internal verifier that will do the default hostname
 * check.
 */
    grpc_tls_certificate_verifier* grpc_tls_certificate_verifier_host_name_create() @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Factory function for an internal verifier that won't perform any
 * post-handshake verification. Note: using this solely without any other
 * authentication mechanisms on the peer identity will leave your applications
 * to the MITM(Man-In-The-Middle) attacks. Users should avoid doing so in
 * production environments.
 */
    grpc_tls_certificate_verifier* grpc_tls_certificate_verifier_no_op_create() @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Converts an external verifier to an internal verifier.
 * Note that we will not take the ownership of the external_verifier. Callers
 * will need to delete external_verifier in its own destruct function.
 */
    grpc_tls_certificate_verifier* grpc_tls_certificate_verifier_external_create(grpc_tls_certificate_verifier_external*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * A struct containing all the necessary functions a custom external verifier
 * needs to implement to be able to be converted to an internal verifier.
 */
    struct grpc_tls_certificate_verifier_external
    {
        
        void* user_data;
        /**
   * A function pointer containing the verification logic that will be
   * performed after the TLS handshake is done. It could be processed
   * synchronously or asynchronously.
   * - If expected to be processed synchronously, the implementer should
   *   populate the verification result through |sync_status| and
   *   |sync_error_details|, and then return true.
   * - If expected to be processed asynchronously, the implementer should return
   *   false immediately, and then in the asynchronous thread invoke |callback|
   *   with the verification result. The implementer MUST NOT invoke the async
   *   |callback| in the same thread before |verify| returns, otherwise it can
   *   lead to deadlocks.
   *
   * user_data: any argument that is passed in the user_data of
   *            grpc_tls_certificate_verifier_external during construction time
   *            can be retrieved later here.
   * request: request information exposed to the function implementer.
   * callback: the callback that the function implementer needs to invoke, if
   *           return a non-zero value. It is usually invoked when the
   *           asynchronous verification is done, and serves to bring the
   *           control back to gRPC.
   * callback_arg: A pointer to the internal ExternalVerifier instance. This is
   *               mainly used as an argument in |callback|, if want to invoke
   *               |callback| in async mode.
   * sync_status: indicates if a connection should be allowed. This should only
   *              be used if the verification check is done synchronously.
   * sync_error_details: the error generated while verifying a connection. This
   *                     should only be used if the verification check is done
   *                     synchronously. the implementation must allocate the
   *                     error string via gpr_malloc() or gpr_strdup().
   * return: return 0 if |verify| is expected to be executed asynchronously,
   *         otherwise return a non-zero value.
   */
        int function(void*, grpc_tls_custom_verification_check_request*, grpc_tls_on_custom_verification_check_done_cb, void*, grpc_status_code*, char**) verify;
        /**
   * A function pointer that cleans up the caller-specified resources when the
   * verifier is still running but the whole connection got cancelled. This
   * could happen when the verifier is doing some async operations, and the
   * whole handshaker object got destroyed because of connection time limit is
   * reached, or any other reasons. In such cases, function implementers might
   * want to be notified, and properly clean up some resources.
   *
   * user_data: any argument that is passed in the user_data of
   *            grpc_tls_certificate_verifier_external during construction time
   *            can be retrieved later here.
   * request: request information exposed to the function implementer. It will
   *          be the same request object that was passed to verify(), and it
   *          tells the cancel() which request to cancel.
   */
        void function(void*, grpc_tls_custom_verification_check_request*) cancel;
        /**
   * A function pointer that does some additional destruction work when the
   * verifier is destroyed. This is used when the caller wants to associate some
   * objects to the lifetime of external_verifier, and destroy them when
   * external_verifier got destructed. For example, in C++, the class containing
   * user-specified callback functions should not be destroyed before
   * external_verifier, since external_verifier will invoke them while being
   * used.
   * Note that the caller MUST delete the grpc_tls_certificate_verifier_external
   * object itself in this function, otherwise it will cause memory leaks. That
   * also means the user_data has to carries at least a self pointer, for the
   * callers to later delete it in destruct().
   *
   * user_data: any argument that is passed in the user_data of
   *            grpc_tls_certificate_verifier_external during construction time
   *            can be retrieved later here.
   */
        void function(void*) destruct;
    }
    struct grpc_tls_certificate_verifier;
    alias grpc_tls_on_custom_verification_check_done_cb = void function(grpc_tls_custom_verification_check_request*, void*, grpc_status_code, const(char)*);
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * The read-only request information exposed in a verification call.
 * Callers should not directly manage the ownership of it. We will make sure it
 * is always available inside verify() or cancel() call, and will destroy the
 * object at the end of custom verification.
 */
    struct grpc_tls_custom_verification_check_request
    {
        
        const(char)* target_name;
        
        struct peer_info
        {
            
            const(char)* common_name;
            
            struct san_names
            {
                
                char** uri_names;
                
                size_t uri_names_size;
                
                char** dns_names;
                
                size_t dns_names_size;
                
                char** email_names;
                
                size_t email_names_size;
                
                char** ip_names;
                
                size_t ip_names_size;
            }
            
            grpc_tls_custom_verification_check_request.peer_info.san_names san_names_;
            
            const(char)* peer_cert;
            
            const(char)* peer_cert_full_chain;
            
            const(char)* verified_root_cert_subject;
        }
        
        grpc_tls_custom_verification_check_request.peer_info peer_info_;
    }
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Sets the options of whether to verify server certs on the client side.
 * Passing in a non-zero value indicates verifying the certs.
 */
    void grpc_tls_credentials_options_set_verify_server_cert(grpc_tls_credentials_options*, int) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * If set, gRPC will read all hashed x.509 CRL files in the directory and
 * enforce the CRL files on all TLS handshakes. Only supported for OpenSSL
 * version > 1.1.
 * It is used for experimental purpose for now and subject to change.
 */
    void grpc_tls_credentials_options_set_crl_directory(grpc_tls_credentials_options*, const(char)*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Sets the options of whether to request and/or verify client certs. This shall
 * only be called on the server side.
 */
    void grpc_tls_credentials_options_set_cert_request_type(grpc_tls_credentials_options*, grpc_ssl_client_certificate_request_type) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Sets the name of the identity certificates being watched.
 * If not set, We will use a default empty string as the identity certificate
 * name.
 */
    void grpc_tls_credentials_options_set_identity_cert_name(grpc_tls_credentials_options*, const(char)*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * If set, gRPC stack will keep watching the identity key-cert pairs
 * with name |identity_cert_name|.
 * This is required on the server side, and optional on the client side.
 */
    void grpc_tls_credentials_options_watch_identity_key_cert_pairs(grpc_tls_credentials_options*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Sets the name of the root certificates being watched.
 * If not set, We will use a default empty string as the root certificate name.
 */
    void grpc_tls_credentials_options_set_root_cert_name(grpc_tls_credentials_options*, const(char)*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * If set, gRPC stack will keep watching the root certificates with
 * name |root_cert_name|.
 * If this is not set on the client side, we will use the root certificates
 * stored in the default system location, since client side must provide root
 * certificates in TLS.
 * If this is not set on the server side, we will not watch any root certificate
 * updates, and assume no root certificates needed for the server(single-side
 * TLS). Default root certs on the server side is not supported.
 */
    void grpc_tls_credentials_options_watch_root_certs(grpc_tls_credentials_options*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Sets the credential provider in the options.
 * The |options| will implicitly take a new ref to the |provider|.
 */
    void grpc_tls_credentials_options_set_certificate_provider(grpc_tls_credentials_options*, grpc_tls_certificate_provider*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Creates an grpc_tls_credentials_options.
 */
    grpc_tls_credentials_options* grpc_tls_credentials_options_create() @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Releases a grpc_tls_certificate_provider object. The creator of the
 * grpc_tls_certificate_provider object is responsible for its release.
 */
    void grpc_tls_certificate_provider_release(grpc_tls_certificate_provider*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Creates a grpc_tls_certificate_provider that will watch the credential
 * changes on the file system. This provider will always return the up-to-date
 * cert data for all the cert names callers set through
 * |grpc_tls_credentials_options|. Note that this API only supports one key-cert
 * file and hence one set of identity key-cert pair, so SNI(Server Name
 * Indication) is not supported.
 * - private_key_path is the file path of the private key. This must be set if
 *   |identity_certificate_path| is set. Otherwise, it could be null if no
 *   identity credentials are needed.
 * - identity_certificate_path is the file path of the identity certificate
 *   chain. This must be set if |private_key_path| is set. Otherwise, it could
 *   be null if no identity credentials are needed.
 * - root_cert_path is the file path to the root certificate bundle. This
 *   may be null if no root certs are needed.
 * - refresh_interval_sec is the refreshing interval that we will check the
 *   files for updates.
 * It does not take ownership of parameters.
 */
    grpc_tls_certificate_provider* grpc_tls_certificate_provider_file_watcher_create(const(char)*, const(char)*, const(char)*, uint) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Creates a grpc_tls_certificate_provider that will load credential data from
 * static string during initialization. This provider will always return the
 * same cert data for all cert names.
 * root_certificate and pem_key_cert_pairs can be nullptr, indicating the
 * corresponding credential data is not needed.
 * This function will make a copy of |root_certificate|.
 * The ownership of |pem_key_cert_pairs| is transferred.
 */
    grpc_tls_certificate_provider* grpc_tls_certificate_provider_static_data_create(const(char)*, grpc_tls_identity_pairs*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Destroys a grpc_tls_identity_pairs object. If this object is passed to a
 * provider initiation function, the ownership is transferred so this function
 * doesn't need to be called. Otherwise the creator of the
 * grpc_tls_identity_pairs object is responsible for its destruction.
 */
    void grpc_tls_identity_pairs_destroy(grpc_tls_identity_pairs*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Adds a identity private key and a identity certificate chain to
 * grpc_tls_identity_pairs. This function will make an internal copy of
 * |private_key| and |cert_chain|.
 */
    void grpc_tls_identity_pairs_add_pair(grpc_tls_identity_pairs*, const(char)*, const(char)*) @nogc nothrow;
    /**
 * EXPERIMENTAL API - Subject to change
 *
 * Creates a grpc_tls_identity_pairs that stores a list of identity credential
 * data, including identity private key and identity certificate chain.
 */
    grpc_tls_identity_pairs* grpc_tls_identity_pairs_create() @nogc nothrow;
    struct grpc_tls_identity_pairs;
    struct grpc_tls_certificate_provider;
    struct grpc_tls_credentials_options;
    /**
 * This method creates a local server credential object. It is used for
 * experimental purpose for now and subject to change.
 *
 * - type: local connection type
 *
 * It returns the created local server credential object.
 */
    grpc_server_credentials* grpc_local_server_credentials_create(grpc_local_connect_type) @nogc nothrow;
    /**
 * This method creates a local channel credential object. The security level
 * of the resulting connection is GRPC_PRIVACY_AND_INTEGRITY for UDS and
 * GRPC_SECURITY_NONE for LOCAL_TCP. It is used for experimental purpose
 * for now and subject to change.
 *
 * - type: local connection type
 *
 * It returns the created local channel credential object.
 */
    grpc_channel_credentials* grpc_local_credentials_create(grpc_local_connect_type) @nogc nothrow;
    /**
 * This method creates an ALTS server credential object. It is used for
 * experimental purpose for now and subject to change.
 *
 * - options: grpc ALTS credentials options instance for server.
 *
 * It returns the created ALTS server credential object.
 */
    grpc_server_credentials* grpc_alts_server_credentials_create(const(grpc_alts_credentials_options)*) @nogc nothrow;
    /**
 * This method creates an ALTS channel credential object. The security
 * level of the resulting connection is GRPC_PRIVACY_AND_INTEGRITY.
 * It is used for experimental purpose for now and subject to change.
 *
 * - options: grpc ALTS credentials options instance for client.
 *
 * It returns the created ALTS channel credential object.
 */
    grpc_channel_credentials* grpc_alts_credentials_create(const(grpc_alts_credentials_options)*) @nogc nothrow;
    /**
 * This method destroys a grpc_alts_credentials_options instance by
 * de-allocating all of its occupied memory. It is used for experimental purpose
 * for now and subject to change.
 *
 * - options: a grpc_alts_credentials_options instance that needs to be
 *   destroyed.
 */
    void grpc_alts_credentials_options_destroy(grpc_alts_credentials_options*) @nogc nothrow;
    /**
 * This method adds a target service account to grpc client's ALTS credentials
 * options instance. It is used for experimental purpose for now and subject
 * to change.
 *
 * - options: grpc ALTS credentials options instance.
 * - service_account: service account of target endpoint.
 */
    void grpc_alts_credentials_client_options_add_target_service_account(grpc_alts_credentials_options*, const(char)*) @nogc nothrow;
    /**
 * This method creates a grpc ALTS credentials server options instance.
 * It is used for experimental purpose for now and subject to change.
 */
    grpc_alts_credentials_options* grpc_alts_credentials_server_options_create() @nogc nothrow;
    /**
 * This method creates a grpc ALTS credentials client options instance.
 * It is used for experimental purpose for now and subject to change.
 */
    grpc_alts_credentials_options* grpc_alts_credentials_client_options_create() @nogc nothrow;
    struct grpc_alts_credentials_options;
    
    void grpc_server_credentials_set_auth_metadata_processor(grpc_server_credentials*, grpc_auth_metadata_processor) @nogc nothrow;
    /** Pluggable server-side metadata processor object. */
    struct grpc_auth_metadata_processor
    {
        /** The context object is read/write: it contains the properties of the
     channel peer and it is the job of the process function to augment it with
     properties derived from the passed-in metadata.
     The lifetime of these objects is guaranteed until cb is invoked. */
        void function(void*, grpc_auth_context*, const(grpc_metadata)*, size_t, grpc_process_auth_metadata_done_cb, void*) process;
        
        void function(void*) destroy;
        
        void* state;
    }
    alias grpc_process_auth_metadata_done_cb = void function(void*, const(grpc_metadata)*, c_ulong, const(grpc_metadata)*, c_ulong, grpc_status_code, const(char)*);
    /** Sets a credentials to a call. Can only be called on the client side before
   grpc_call_start_batch. */
    grpc_call_error grpc_call_set_credentials(grpc_call*, grpc_call_credentials*) @nogc nothrow;
    /** Creates an SSL server_credentials object using the provided options struct.
    - Takes ownership of the options parameter. */
    grpc_server_credentials* grpc_ssl_server_credentials_create_with_options(grpc_ssl_server_credentials_options*) @nogc nothrow;
    /** Destroys a grpc_ssl_server_credentials_options object. */
    void grpc_ssl_server_credentials_options_destroy(grpc_ssl_server_credentials_options*) @nogc nothrow;
    /** Creates an options object using a certificate config fetcher. Use this
   method to reload the certificates and keys of the SSL server without
   interrupting the operation of the server. Initial certificate config will be
   fetched during server initialization.
   - user_data parameter, if not NULL, contains opaque data which will be passed
     to the fetcher (see definition of
     grpc_ssl_server_certificate_config_callback). */
    grpc_ssl_server_credentials_options* grpc_ssl_server_credentials_create_options_using_config_fetcher(grpc_ssl_client_certificate_request_type, grpc_ssl_server_certificate_config_callback, void*) @nogc nothrow;
    /** Creates an options object using a certificate config. Use this method when
   the certificates and keys of the SSL server will not change during the
   server's lifetime.
   - Takes ownership of the certificate_config parameter. */
    grpc_ssl_server_credentials_options* grpc_ssl_server_credentials_create_options_using_config(grpc_ssl_client_certificate_request_type, grpc_ssl_server_certificate_config*) @nogc nothrow;
    struct grpc_ssl_server_credentials_options;
    /** Deprecated in favor of grpc_ssl_server_credentials_create_with_options.
   Same as grpc_ssl_server_credentials_create method except uses
   grpc_ssl_client_certificate_request_type enum to support more ways to
   authenticate client certificates.*/
    grpc_server_credentials* grpc_ssl_server_credentials_create_ex(const(char)*, grpc_ssl_pem_key_cert_pair*, size_t, grpc_ssl_client_certificate_request_type, void*) @nogc nothrow;
    /** Deprecated in favor of grpc_ssl_server_credentials_create_ex.
   Creates an SSL server_credentials object.
   - pem_roots_cert is the NULL-terminated string containing the PEM encoding of
     the client root certificates. This parameter may be NULL if the server does
     not want the client to be authenticated with SSL.
   - pem_key_cert_pairs is an array private key / certificate chains of the
     server. This parameter cannot be NULL.
   - num_key_cert_pairs indicates the number of items in the private_key_files
     and cert_chain_files parameters. It should be at least 1.
   - force_client_auth, if set to non-zero will force the client to authenticate
     with an SSL cert. Note that this option is ignored if pem_root_certs is
     NULL. */
    grpc_server_credentials* grpc_ssl_server_credentials_create(const(char)*, grpc_ssl_pem_key_cert_pair*, size_t, int, void*) @nogc nothrow;
    alias grpc_ssl_server_certificate_config_callback = grpc_ssl_certificate_config_reload_status function(void*, grpc_ssl_server_certificate_config**);
    /** Destroys a grpc_ssl_server_certificate_config object. */
    void grpc_ssl_server_certificate_config_destroy(grpc_ssl_server_certificate_config*) @nogc nothrow;
    /** Creates a grpc_ssl_server_certificate_config object.
   - pem_roots_cert is the NULL-terminated string containing the PEM encoding of
     the client root certificates. This parameter may be NULL if the server does
     not want the client to be authenticated with SSL.
   - pem_key_cert_pairs is an array private key / certificate chains of the
     server. This parameter cannot be NULL.
   - num_key_cert_pairs indicates the number of items in the private_key_files
     and cert_chain_files parameters. It must be at least 1.
   - It is the caller's responsibility to free this object via
     grpc_ssl_server_certificate_config_destroy(). */
    grpc_ssl_server_certificate_config* grpc_ssl_server_certificate_config_create(const(char)*, const(grpc_ssl_pem_key_cert_pair)*, size_t) @nogc nothrow;
    struct grpc_ssl_server_certificate_config;
    /** Creates a credentials object from a plugin with a specified minimum security
 * level. */
    grpc_call_credentials* grpc_metadata_credentials_create_from_plugin(grpc_metadata_credentials_plugin, grpc_security_level, void*) @nogc nothrow;
    /** grpc_metadata_credentials plugin is an API user provided structure used to
   create grpc_credentials objects that can be set on a channel (composed) or
   a call. See grpc_credentials_metadata_create_from_plugin below.
   The grpc client stack will call the get_metadata method of the plugin for
   every call in scope for the credentials created from it. */
    struct grpc_metadata_credentials_plugin
    {
        /** The implementation of this method has to be non-blocking, but can
     be performed synchronously or asynchronously.

     If processing occurs synchronously, returns non-zero and populates
     creds_md, num_creds_md, status, and error_details.  In this case,
     the caller takes ownership of the entries in creds_md and of
     error_details.  Note that if the plugin needs to return more than
     GRPC_METADATA_CREDENTIALS_PLUGIN_SYNC_MAX entries in creds_md, it must
     return asynchronously.

     If processing occurs asynchronously, returns zero and invokes \a cb
     when processing is completed.  \a user_data will be passed as the
     first parameter of the callback.  NOTE: \a cb MUST be invoked in a
     different thread, not from the thread in which \a get_metadata() is
     invoked.

     \a context is the information that can be used by the plugin to create
     auth metadata. */
        int function(void*, grpc_auth_metadata_context, grpc_credentials_plugin_metadata_cb, void*, grpc_metadata[4], size_t*, grpc_status_code*, const(char)**) get_metadata;
        /** Implements debug string of the given plugin. This method returns an
   * allocated string that the caller needs to free using gpr_free() */
        char* function(void*) debug_string;
        /** Destroys the plugin state. */
        void function(void*) destroy;
        /** State that will be set as the first parameter of the methods above. */
        void* state;
        /** Type of credentials that this plugin is implementing. */
        const(char)* type;
    }
    /** Releases internal resources held by \a context. **/
    void grpc_auth_metadata_context_reset(grpc_auth_metadata_context*) @nogc nothrow;
    /** Performs a deep copy from \a from to \a to. **/
    void grpc_auth_metadata_context_copy(grpc_auth_metadata_context*, grpc_auth_metadata_context*) @nogc nothrow;
    /** Context that can be used by metadata credentials plugin in order to create
   auth related metadata. */
    struct grpc_auth_metadata_context
    {
        /** The fully qualifed service url. */
        const(char)* service_url;
        /** The method name of the RPC being called (not fully qualified).
     The fully qualified method name can be built from the service_url:
     full_qualified_method_name = ctx->service_url + '/' + ctx->method_name. */
        const(char)* method_name;
        /** The auth_context of the channel which gives the server's identity. */
        const(grpc_auth_context)* channel_auth_context;
        /** Reserved for future use. */
        void* reserved;
    }
    alias grpc_credentials_plugin_metadata_cb = void function(void*, const(grpc_metadata)*, c_ulong, grpc_status_code, const(char)*);
    /** Creates an STS credentials following the STS Token Exchanged specifed in the
   IETF draft https://tools.ietf.org/html/draft-ietf-oauth-token-exchange-16.
   This API is used for experimental purposes for now and may change in the
   future. */
    grpc_call_credentials* grpc_sts_credentials_create(const(grpc_sts_credentials_options)*, void*) @nogc nothrow;
    /** Options for creating STS Oauth Token Exchange credentials following the IETF
   draft https://tools.ietf.org/html/draft-ietf-oauth-token-exchange-16.
   Optional fields may be set to NULL or empty string. It is the responsibility
   of the caller to ensure that the subject and actor tokens are refreshed on
   disk at the specified paths. This API is used for experimental purposes for
   now and may change in the future. */
    struct grpc_sts_credentials_options
    {
        
        const(char)* token_exchange_service_uri;
        
        const(char)* resource;
        
        const(char)* audience;
        
        const(char)* scope_;
        
        const(char)* requested_token_type;
        
        const(char)* subject_token_path;
        
        const(char)* subject_token_type;
        
        const(char)* actor_token_path;
        
        const(char)* actor_token_type;
    }
    /** Creates an IAM credentials object for connecting to Google. */
    grpc_call_credentials* grpc_google_iam_credentials_create(const(char)*, const(char)*, void*) @nogc nothrow;
    /** Creates an Oauth2 Access Token credentials with an access token that was
   acquired by an out of band mechanism. */
    grpc_call_credentials* grpc_access_token_credentials_create(const(char)*, void*) @nogc nothrow;
    /** Creates an Oauth2 Refresh Token credentials object for connecting to Google.
   May return NULL if the input is invalid.
   WARNING: Do NOT use this credentials to connect to a non-google service as
   this could result in an oauth2 token leak.
   - json_refresh_token is the JSON string containing the refresh token itself
     along with a client_id and client_secret. */
    grpc_call_credentials* grpc_google_refresh_token_credentials_create(const(char)*, void*) @nogc nothrow;
    /** Builds External Account credentials.
 - json_string is the JSON string containing the credentials options.
 - scopes_string contains the scopes to be binded with the credentials.
   This API is used for experimental purposes for now and may change in the
 future. */
    grpc_call_credentials* grpc_external_account_credentials_create(const(char)*, const(char)*) @nogc nothrow;
    /** Creates a JWT credentials object. May return NULL if the input is invalid.
   - json_key is the JSON key string containing the client's private key.
   - token_lifetime is the lifetime of each Json Web Token (JWT) created with
     this credentials.  It should not exceed grpc_max_auth_token_lifetime or
     will be cropped to this value.  */
    grpc_call_credentials* grpc_service_account_jwt_access_credentials_create(const(char)*, gpr_timespec, void*) @nogc nothrow;
    
    gpr_timespec grpc_max_auth_token_lifetime() @nogc nothrow;
    /** Creates a compute engine credentials object for connecting to Google.
   WARNING: Do NOT use this credentials to connect to a non-google service as
   this could result in an oauth2 token leak. */
    grpc_call_credentials* grpc_google_compute_engine_credentials_create(void*) @nogc nothrow;
    /** Creates a composite call credentials object. */
    grpc_call_credentials* grpc_composite_call_credentials_create(grpc_call_credentials*, grpc_call_credentials*, void*) @nogc nothrow;
    /** Creates a composite channel credentials object. The security level of
 * resulting connection is determined by channel_creds. */
    grpc_channel_credentials* grpc_composite_channel_credentials_create(grpc_channel_credentials*, grpc_call_credentials*, void*) @nogc nothrow;
    
    grpc_channel_credentials* grpc_ssl_credentials_create_ex(const(char)*, grpc_ssl_pem_key_cert_pair*, const(grpc_ssl_verify_peer_options)*, void*) @nogc nothrow;
    /** Deprecated in favor of grpc_ssl_server_credentials_create_ex. It will be
   removed after all of its call sites are migrated to
   grpc_ssl_server_credentials_create_ex. Creates an SSL credentials object.
   The security level of the resulting connection is GRPC_PRIVACY_AND_INTEGRITY.
   - pem_root_certs is the NULL-terminated string containing the PEM encoding
     of the server root certificates. If this parameter is NULL, the
     implementation will first try to dereference the file pointed by the
     GRPC_DEFAULT_SSL_ROOTS_FILE_PATH environment variable, and if that fails,
     try to get the roots set by grpc_override_ssl_default_roots. Eventually,
     if all these fail, it will try to get the roots from a well-known place on
     disk (in the grpc install directory).

     gRPC has implemented root cache if the underlying OpenSSL library supports
     it. The gRPC root certificates cache is only applicable on the default
     root certificates, which is used when this parameter is nullptr. If user
     provides their own pem_root_certs, when creating an SSL credential object,
     gRPC would not be able to cache it, and each subchannel will generate a
     copy of the root store. So it is recommended to avoid providing large room
     pem with pem_root_certs parameter to avoid excessive memory consumption,
     particularly on mobile platforms such as iOS.
   - pem_key_cert_pair is a pointer on the object containing client's private
     key and certificate chain. This parameter can be NULL if the client does
     not have such a key/cert pair.
   - verify_options is an optional verify_peer_options object which holds
     additional options controlling how peer certificates are verified. For
     example, you can supply a callback which receives the peer's certificate
     with which you can do additional verification. Can be NULL, in which
     case verification will retain default behavior. Any settings in
     verify_options are copied during this call, so the verify_options
     object can be released afterwards. */
    grpc_channel_credentials* grpc_ssl_credentials_create(const(char)*, grpc_ssl_pem_key_cert_pair*, const(verify_peer_options)*, void*) @nogc nothrow;
    /** Object that holds additional peer-verification options on a secure
   channel. */
    struct grpc_ssl_verify_peer_options
    {
        /** If non-NULL this callback will be invoked with the expected
     target_name, the peer's certificate (in PEM format), and whatever
     userdata pointer is set below. If a non-zero value is returned by this
     callback then it is treated as a verification failure. Invocation of
     the callback is blocking, so any implementation should be light-weight.
     */
        int function(const(char)*, const(char)*, void*) verify_peer_callback;
        /** Arbitrary userdata that will be passed as the last argument to
     verify_peer_callback. */
        void* verify_peer_callback_userdata;
        /** A destruct callback that will be invoked when the channel is being
     cleaned up. The userdata argument will be passed to it. The intent is
     to perform any cleanup associated with that userdata. */
        void function(void*) verify_peer_destruct;
    }
    /** Deprecated in favor of grpc_ssl_verify_peer_options. It will be removed
  after all of its call sites are migrated to grpc_ssl_verify_peer_options.
  Object that holds additional peer-verification options on a secure
  channel. */
    struct verify_peer_options
    {
        /** If non-NULL this callback will be invoked with the expected
     target_name, the peer's certificate (in PEM format), and whatever
     userdata pointer is set below. If a non-zero value is returned by this
     callback then it is treated as a verification failure. Invocation of
     the callback is blocking, so any implementation should be light-weight.
     */
        int function(const(char)*, const(char)*, void*) verify_peer_callback;
        /** Arbitrary userdata that will be passed as the last argument to
     verify_peer_callback. */
        void* verify_peer_callback_userdata;
        /** A destruct callback that will be invoked when the channel is being
     cleaned up. The userdata argument will be passed to it. The intent is
     to perform any cleanup associated with that userdata. */
        void function(void*) verify_peer_destruct;
    }
    /** Object that holds a private key / certificate chain pair in PEM format. */
    struct grpc_ssl_pem_key_cert_pair
    {
        /** private_key is the NULL-terminated string containing the PEM encoding of
     the client's private key. */
        const(char)* private_key;
        /** cert_chain is the NULL-terminated string containing the PEM encoding of
     the client's certificate chain. */
        const(char)* cert_chain;
    }
    /** Setup a callback to override the default TLS/SSL roots.
   This function is not thread-safe and must be called at initialization time
   before any ssl credentials are created to have the desired side effect.
   If GRPC_DEFAULT_SSL_ROOTS_FILE_PATH environment is set to a valid path, the
   callback will not be called. */
    void grpc_set_ssl_roots_override_callback(grpc_ssl_roots_override_callback) @nogc nothrow;
    alias grpc_ssl_roots_override_callback = grpc_ssl_roots_override_result function(char**);
    /** Creates default credentials to connect to a google gRPC service.
   WARNING: Do NOT use this credentials to connect to a non-google service as
   this could result in an oauth2 token leak. The security level of the
   resulting connection is GRPC_PRIVACY_AND_INTEGRITY.

   If specified, the supplied call credentials object will be attached to the
   returned channel credentials object. The call_credentials object must remain
   valid throughout the lifetime of the returned grpc_channel_credentials
   object. It is expected that the call credentials object was generated
   according to the Application Default Credentials mechanism and asserts the
   identity of the default service account of the machine. Supplying any other
   sort of call credential will result in undefined behavior, up to and
   including the sudden and unexpected failure of RPCs.

   If nullptr is supplied, the returned channel credentials object will use a
   call credentials object based on the Application Default Credentials
   mechanism.
*/
    grpc_channel_credentials* grpc_google_default_credentials_create(grpc_call_credentials*) @nogc nothrow;
    /** Releases a call credentials object.
   The creator of the credentials object is responsible for its release. */
    void grpc_call_credentials_release(grpc_call_credentials*) @nogc nothrow;
    struct grpc_call_credentials;
    /** Create a channel arg with the given cache object. */
    grpc_arg grpc_ssl_session_cache_create_channel_arg(grpc_ssl_session_cache*) @nogc nothrow;
    /** Destroy SSL session cache. */
    void grpc_ssl_session_cache_destroy(grpc_ssl_session_cache*) @nogc nothrow;
    /** Create LRU cache for client-side SSL sessions with the given capacity.
    If capacity is < 1, a default capacity is used instead. */
    grpc_ssl_session_cache* grpc_ssl_session_cache_create_lru(size_t) @nogc nothrow;
    struct grpc_ssl_session_cache;
    /** Sets the property name. Returns 1 if successful or 0 in case of failure
   (which means that no property with this name exists). */
    int grpc_auth_context_set_peer_identity_property_name(grpc_auth_context*, const(char)*) @nogc nothrow;
    /** Add a C string property. */
    void grpc_auth_context_add_cstring_property(grpc_auth_context*, const(char)*, const(char)*) @nogc nothrow;
    /** Add a property. */
    void grpc_auth_context_add_property(grpc_auth_context*, const(char)*, const(char)*, size_t) @nogc nothrow;
    /** Releases the auth context returned from grpc_call_auth_context. */
    void grpc_auth_context_release(grpc_auth_context*) @nogc nothrow;
    /** Gets the auth context from the call. Caller needs to call
   grpc_auth_context_release on the returned context. */
    grpc_auth_context* grpc_call_auth_context(grpc_call*) @nogc nothrow;
    /** Returns 1 if the peer is authenticated, 0 otherwise. */
    int grpc_auth_context_peer_is_authenticated(const(grpc_auth_context)*) @nogc nothrow;
    /** Gets the name of the property that indicates the peer identity. Will return
   NULL if the peer is not authenticated. */
    const(char)* grpc_auth_context_peer_identity_property_name(const(grpc_auth_context)*) @nogc nothrow;
    /** Finds a property in the context. May return an empty iterator (first _next
   will return NULL) if no property with this name was found in the context. */
    grpc_auth_property_iterator grpc_auth_context_find_properties_by_name(const(grpc_auth_context)*, const(char)*) @nogc nothrow;
    /** Gets the peer identity. Returns an empty iterator (first _next will return
   NULL) if the peer is not authenticated. */
    grpc_auth_property_iterator grpc_auth_context_peer_identity(const(grpc_auth_context)*) @nogc nothrow;
    /** Iterates over the auth context. */
    grpc_auth_property_iterator grpc_auth_context_property_iterator(const(grpc_auth_context)*) @nogc nothrow;
    /** Returns NULL when the iterator is at the end. */
    const(grpc_auth_property)* grpc_auth_property_iterator_next(grpc_auth_property_iterator*) @nogc nothrow;
    /** value, if not NULL, is guaranteed to be NULL terminated. */
    struct grpc_auth_property
    {
        
        char* name;
        
        char* value;
        
        size_t value_length;
    }
    
    struct grpc_auth_property_iterator
    {
        
        const(grpc_auth_context)* ctx;
        
        size_t index;
        
        const(char)* name;
    }
    struct grpc_auth_context;
    /**
 * EXPERIMENTAL - Subject to change.
 * Fetch a vtable for grpc_channel_arg that points to
 * grpc_authorization_policy_provider.
 */
    const(grpc_arg_pointer_vtable)* grpc_authorization_policy_provider_arg_vtable() @nogc nothrow;
    
    char* grpc_channelz_get_socket(intptr_t) @nogc nothrow;
    
    char* grpc_channelz_get_subchannel(intptr_t) @nogc nothrow;
    
    char* grpc_channelz_get_channel(intptr_t) @nogc nothrow;
    
    char* grpc_channelz_get_server_sockets(intptr_t, intptr_t, intptr_t) @nogc nothrow;
    
    char* grpc_channelz_get_server(intptr_t) @nogc nothrow;
    
    char* grpc_channelz_get_servers(intptr_t) @nogc nothrow;
    /************* CHANNELZ API *************/
/** Channelz is under active development. The following APIs will see some
    churn as the feature is implemented. This comment will be removed once
    channelz is officially supported, and these APIs become stable. For now
    you may track the progress by following this github issue:
    https://github.com/grpc/grpc/issues/15340

    the following APIs return allocated JSON strings that match the response
    objects from the channelz proto, found here:
    https://github.com/grpc/grpc/blob/master/src/proto/grpc/channelz/channelz.proto.

    For easy conversion to protobuf, The JSON is formatted according to:
    https://developers.google.com/protocol-buffers/docs/proto3#json. */
    char* grpc_channelz_get_top_channels(intptr_t) @nogc nothrow;
    /** Fetch a vtable for a grpc_channel_arg that points to a grpc_resource_quota
 */
    const(grpc_arg_pointer_vtable)* grpc_resource_quota_arg_vtable() @nogc nothrow;
    /** EXPERIMENTAL.  Dumps xDS configs as a serialized ClientConfig proto.
    The full name of the proto is envoy.service.status.v3.ClientConfig. */
    grpc_slice grpc_dump_xds_configs() @nogc nothrow;
    /** Update the size of the maximum number of threads allowed */
    void grpc_resource_quota_set_max_threads(grpc_resource_quota*, int) @nogc nothrow;
    /** Update the size of a buffer pool */
    void grpc_resource_quota_resize(grpc_resource_quota*, size_t) @nogc nothrow;
    /** Drop a reference to a buffer pool */
    void grpc_resource_quota_unref(grpc_resource_quota*) @nogc nothrow;
    /** Add a reference to a buffer pool */
    void grpc_resource_quota_ref(grpc_resource_quota*) @nogc nothrow;
    /** Create a buffer pool */
    grpc_resource_quota* grpc_resource_quota_create(const(char)*) @nogc nothrow;
    /** Convert grpc_call_error values to a string */
    const(char)* grpc_call_error_to_string(grpc_call_error) @nogc nothrow;
    /** Check whether a metadata key corresponds to a binary value */
    int grpc_is_binary_header(grpc_slice) @nogc nothrow;
    /** Check whether a non-binary metadata value is legal (will be accepted by
    core) */
    int grpc_header_nonbin_value_is_legal(grpc_slice) @nogc nothrow;
    /** Check whether a metadata key is legal (will be accepted by core) */
    int grpc_header_key_is_legal(grpc_slice) @nogc nothrow;
    /** Enable or disable a tracer.

    Tracers (usually controlled by the environment variable GRPC_TRACE)
    allow printf-style debugging on GRPC internals, and are useful for
    tracking down problems in the field.

    Use of this function is not strictly thread-safe, but the
    thread-safety issues raised by it should not be of concern. */
    int grpc_tracer_set_enabled(const(char)*, int) @nogc nothrow;
    /** Destroy a server.
    Shutdown must have completed beforehand (i.e. all tags generated by
    grpc_server_shutdown_and_notify must have been received, and at least
    one call to grpc_server_shutdown_and_notify must have been made). */
    void grpc_server_destroy(grpc_server*) @nogc nothrow;
    /** Cancel all in-progress calls.
    Only usable after shutdown. */
    void grpc_server_cancel_all_calls(grpc_server*) @nogc nothrow;
    /** Begin shutting down a server.
    After completion, no new calls or connections will be admitted.
    Existing calls will be allowed to complete.
    Send a GRPC_OP_COMPLETE event when there are no more calls being serviced.
    Shutdown is idempotent, and all tags will be notified at once if multiple
    grpc_server_shutdown_and_notify calls are made. 'cq' must have been
    registered to this server via grpc_server_register_completion_queue. */
    void grpc_server_shutdown_and_notify(grpc_server*, grpc_completion_queue*, void*) @nogc nothrow;
    /** Start a server - tells all listeners to start listening */
    void grpc_server_start(grpc_server*) @nogc nothrow;
    /** Add a HTTP2 over an encrypted link over tcp listener.
   Returns bound port number on success, 0 on failure.
   REQUIRES: server not started */
    int grpc_server_add_http2_port(grpc_server*, const(char)*, grpc_server_credentials*) @nogc nothrow;
    /** EXPERIMENTAL.  Sets the server's config fetcher.  Takes ownership.
    Must be called before adding ports */
    void grpc_server_set_config_fetcher(grpc_server*, grpc_server_config_fetcher*) @nogc nothrow;
    /** EXPERIMENTAL.  Destroys a config fetcher. */
    void grpc_server_config_fetcher_destroy(grpc_server_config_fetcher*) @nogc nothrow;
    /** EXPERIMENTAL.  Creates an xDS config fetcher. */
    grpc_server_config_fetcher* grpc_server_config_fetcher_xds_create(grpc_server_xds_status_notifier, const(grpc_channel_args)*) @nogc nothrow;
    struct grpc_server_config_fetcher;
    
    struct grpc_server_xds_status_notifier
    {
        
        void function(void*, const(char)*, grpc_serving_status_update) on_serving_status_update;
        
        void* user_data;
    }
    
    struct grpc_serving_status_update
    {
        
        grpc_status_code code;
        
        const(char)* error_message;
    }
    /** Register a completion queue with the server. Must be done for any
    notification completion queue that is passed to grpc_server_request_*_call
    and to grpc_server_shutdown_and_notify. Must be performed prior to
    grpc_server_start. */
    void grpc_server_register_completion_queue(grpc_server*, grpc_completion_queue*, void*) @nogc nothrow;
    /** Create a server. Additional configuration for each incoming channel can
    be specified with args. If no additional configuration is needed, args can
    be NULL. The user data in 'args' need only live through the invocation of
    this function. However, if any args of the 'pointer' type are passed, then
    the referenced vtable must be maintained by the caller until
    grpc_server_destroy terminates. See grpc_channel_args definition for more
    on this. */
    grpc_server* grpc_server_create(const(grpc_channel_args)*, void*) @nogc nothrow;
    /** Request notification of a new pre-registered call. 'cq_for_notification'
    must have been registered to the server via
    grpc_server_register_completion_queue. */
    grpc_call_error grpc_server_request_registered_call(grpc_server*, void*, grpc_call**, gpr_timespec*, grpc_metadata_array*, grpc_byte_buffer**, grpc_completion_queue*, grpc_completion_queue*, void*) @nogc nothrow;
    /** Registers a method in the server.
    Methods to this (host, method) pair will not be reported by
    grpc_server_request_call, but instead be reported by
    grpc_server_request_registered_call when passed the appropriate
    registered_method (as returned by this function).
    Must be called before grpc_server_start.
    Returns NULL on failure. */
    void* grpc_server_register_method(grpc_server*, const(char)*, const(char)*, grpc_server_register_method_payload_handling, uint32_t) @nogc nothrow;
    /** How to handle payloads for a registered method */
    enum grpc_server_register_method_payload_handling
    {
        /** Don't try to read the payload */
        GRPC_SRM_PAYLOAD_NONE = 0, 
        /** Read the initial payload as a byte buffer */
        GRPC_SRM_PAYLOAD_READ_INITIAL_BYTE_BUFFER = 1, 
    }
    enum GRPC_SRM_PAYLOAD_NONE = grpc_server_register_method_payload_handling.GRPC_SRM_PAYLOAD_NONE;
    enum GRPC_SRM_PAYLOAD_READ_INITIAL_BYTE_BUFFER = grpc_server_register_method_payload_handling.GRPC_SRM_PAYLOAD_READ_INITIAL_BYTE_BUFFER;
    /** Request notification of a new call.
    Once a call is received, a notification tagged with \a tag_new is added to
    \a cq_for_notification. \a call, \a details and \a request_metadata are
    updated with the appropriate call information. \a cq_bound_to_call is bound
    to \a call, and batch operation notifications for that call will be posted
    to \a cq_bound_to_call.
    Note that \a cq_for_notification must have been registered to the server via
    \a grpc_server_register_completion_queue. */
    grpc_call_error grpc_server_request_call(grpc_server*, grpc_call**, grpc_call_details*, grpc_metadata_array*, grpc_completion_queue*, grpc_completion_queue*, void*) @nogc nothrow;
    /** Unref a call.
    THREAD SAFETY: grpc_call_unref is thread-compatible */
    void grpc_call_unref(grpc_call*) @nogc nothrow;
    /** Ref a call.
    THREAD SAFETY: grpc_call_ref is thread-compatible */
    void grpc_call_ref(grpc_call*) @nogc nothrow;
    
    int grpc_call_failed_before_recv_message(const(grpc_call)*) @nogc nothrow;
    /** Cancel an RPC.
    Can be called multiple times, from any thread.
    If a status has not been received for the call, set it to the status code
    and description passed in.
    Importantly, this function does not send status nor description to the
    remote endpoint.
    Note that \a description doesn't need be a static string.
    It doesn't need to be alive after the call to
    grpc_call_cancel_with_status completes.
    */
    grpc_call_error grpc_call_cancel_with_status(grpc_call*, grpc_status_code, const(char)*, void*) @nogc nothrow;
    /** Cancel an RPC.
    Can be called multiple times, from any thread.
    THREAD-SAFETY grpc_call_cancel and grpc_call_cancel_with_status
    are thread-safe, and can be called at any point before grpc_call_unref
    is called.*/
    grpc_call_error grpc_call_cancel(grpc_call*, void*) @nogc nothrow;
    /** Close and destroy a grpc channel */
    void grpc_channel_destroy(grpc_channel*) @nogc nothrow;
    /** Create a lame client: this client fails every operation attempted on it. */
    grpc_channel* grpc_lame_client_channel_create(const(char)*, grpc_status_code, const(char)*) @nogc nothrow;
    /** Creates a secure channel using the passed-in credentials. Additional
    channel level configuration MAY be provided by grpc_channel_args, though
    the expectation is that most clients will want to simply pass NULL. The
    user data in 'args' need only live through the invocation of this function.
    However, if any args of the 'pointer' type are passed, then the referenced
    vtable must be maintained by the caller until grpc_channel_destroy
    terminates. See grpc_channel_args definition for more on this. */
    grpc_channel* grpc_channel_create(const(char)*, grpc_channel_credentials*, const(grpc_channel_args)*) @nogc nothrow;
    /** Releases a server_credentials object.
   The creator of the server_credentials object is responsible for its release.
   */
    void grpc_server_credentials_release(grpc_server_credentials*) @nogc nothrow;
    struct grpc_server_credentials;
    /** Releases a channel credentials object.
   The creator of the credentials object is responsible for its release. */
    void grpc_channel_credentials_release(grpc_channel_credentials*) @nogc nothrow;
    struct grpc_channel_credentials;
    /** EXPERIMENTAL.  Resets the channel's connect backoff.
    TODO(roth): When we see whether this proves useful, either promote
    to non-experimental or remove it. */
    void grpc_channel_reset_connect_backoff(grpc_channel*) @nogc nothrow;
    /** Request info about the channel.
    \a channel_info indicates what information is being requested and
    how that information will be returned.
    \a channel_info is owned by the caller. */
    void grpc_channel_get_info(grpc_channel*, const(grpc_channel_info)*) @nogc nothrow;
    /** Return a newly allocated string representing the target a channel was
    created for. */
    char* grpc_channel_get_target(grpc_channel*) @nogc nothrow;
    /** Retrieve the calls current census context. */
    census_context* grpc_census_call_get_context(grpc_call*) @nogc nothrow;
    /** Set census context for a call; Must be called before first call to
   grpc_call_start_batch(). */
    void grpc_census_call_set_context(grpc_call*, census_context*) @nogc nothrow;
    struct census_context;
    /** Returns a newly allocated string representing the endpoint to which this
    call is communicating with. The string is in the uri format accepted by
    grpc_channel_create.
    The returned string should be disposed of with gpr_free().

    WARNING: this value is never authenticated or subject to any security
    related code. It must not be used for any authentication related
    functionality. Instead, use grpc_auth_context. */
    char* grpc_call_get_peer(grpc_call*) @nogc nothrow;
    /** Start a batch of operations defined in the array ops; when complete, post a
    completion of type 'tag' to the completion queue bound to the call.
    The order of ops specified in the batch has no significance.
    Only one operation of each type can be active at once in any given
    batch.
    If a call to grpc_call_start_batch returns GRPC_CALL_OK you must call
    grpc_completion_queue_next or grpc_completion_queue_pluck on the completion
    queue associated with 'call' for work to be performed. If a call to
    grpc_call_start_batch returns any value other than GRPC_CALL_OK it is
    guaranteed that no state associated with 'call' is changed and it is not
    appropriate to call grpc_completion_queue_next or
    grpc_completion_queue_pluck consequent to the failed grpc_call_start_batch
    call.
    If a call to grpc_call_start_batch with an empty batch returns
    GRPC_CALL_OK, the tag is put in the completion queue immediately.
    THREAD SAFETY: access to grpc_call_start_batch in multi-threaded environment
    needs to be synchronized. As an optimization, you may synchronize batches
    containing just send operations independently from batches containing just
    receive operations. Access to grpc_call_start_batch with an empty batch is
    thread-compatible. */
    grpc_call_error grpc_call_start_batch(grpc_call*, const(grpc_op)*, size_t, void*, void*) @nogc nothrow;
    /** Allocate memory in the grpc_call arena: this memory is automatically
    discarded at call completion */
    void* grpc_call_arena_alloc(grpc_call*, size_t) @nogc nothrow;
    /** Create a call given a handle returned from grpc_channel_register_call.
    \sa grpc_channel_create_call. */
    grpc_call* grpc_channel_create_registered_call(grpc_channel*, grpc_call*, uint32_t, grpc_completion_queue*, void*, gpr_timespec, void*) @nogc nothrow;
    /** Pre-register a method/host pair on a channel.
    method and host are not owned and must remain alive while the channel is
    alive. */
    void* grpc_channel_register_call(grpc_channel*, const(char)*, const(char)*, void*) @nogc nothrow;
    /** Create a call given a grpc_channel, in order to call 'method'. All
    completions are sent to 'completion_queue'. 'method' and 'host' need only
    live through the invocation of this function.
    If parent_call is non-NULL, it must be a server-side call. It will be used
    to propagate properties from the server call to this new client call,
    depending on the value of \a propagation_mask (see propagation_bits.h for
    possible values). */
    grpc_call* grpc_channel_create_call(grpc_channel*, grpc_call*, uint32_t, grpc_completion_queue*, grpc_slice, const(grpc_slice)*, gpr_timespec, void*) @nogc nothrow;
    /** Check whether a grpc channel supports connectivity watcher */
    int grpc_channel_support_connectivity_watcher(grpc_channel*) @nogc nothrow;
    /** Watch for a change in connectivity state.
    Once the channel connectivity state is different from last_observed_state,
    tag will be enqueued on cq with success=1.
    If deadline expires BEFORE the state is changed, tag will be enqueued on cq
    with success=0. */
    void grpc_channel_watch_connectivity_state(grpc_channel*, grpc_connectivity_state, gpr_timespec, grpc_completion_queue*, void*) @nogc nothrow;
    /** Number of active "external connectivity state watchers" attached to a
 * channel.
 * Useful for testing. **/
    int grpc_channel_num_external_connectivity_watchers(grpc_channel*) @nogc nothrow;
    /** Check the connectivity state of a channel. */
    grpc_connectivity_state grpc_channel_check_connectivity_state(grpc_channel*, int) @nogc nothrow;
    /*********** EXPERIMENTAL API ************/
/** Flushes the thread local cache for \a cq.
 * Returns 1 if there was contents in the cache.  If there was an event
 * in \a cq tls cache, its tag is placed in tag, and ok is set to the
 * event success.
 */
    int grpc_completion_queue_thread_local_cache_flush(grpc_completion_queue*, void**, int*) @nogc nothrow;
    /*********** EXPERIMENTAL API ************/
/** Initializes a thread local cache for \a cq.
 * grpc_flush_cq_tls_cache() MUST be called on the same thread,
 * with the same cq.
 */
    void grpc_completion_queue_thread_local_cache_init(grpc_completion_queue*) @nogc nothrow;
    /** Destroy a completion queue. The caller must ensure that the queue is
    drained and no threads are executing grpc_completion_queue_next */
    void grpc_completion_queue_destroy(grpc_completion_queue*) @nogc nothrow;
    /** Begin destruction of a completion queue. Once all possible events are
    drained then grpc_completion_queue_next will start to produce
    GRPC_QUEUE_SHUTDOWN events only. At that point it's safe to call
    grpc_completion_queue_destroy.

    After calling this function applications should ensure that no
    NEW work is added to be published on this completion queue. */
    void grpc_completion_queue_shutdown(grpc_completion_queue*) @nogc nothrow;
    /** Blocks until an event with tag 'tag' is available, the completion queue is
    being shutdown or deadline is reached.

    Returns a grpc_event with type GRPC_QUEUE_TIMEOUT on timeout,
    otherwise a grpc_event describing the event that occurred.

    Callers must not call grpc_completion_queue_next and
    grpc_completion_queue_pluck simultaneously on the same completion queue.

    Completion queues support a maximum of GRPC_MAX_COMPLETION_QUEUE_PLUCKERS
    concurrently executing plucks at any time. */
    grpc_event grpc_completion_queue_pluck(grpc_completion_queue*, void*, gpr_timespec, void*) @nogc nothrow;
    /** Blocks until an event is available, the completion queue is being shut down,
    or deadline is reached.

    Returns a grpc_event with type GRPC_QUEUE_TIMEOUT on timeout,
    otherwise a grpc_event describing the event that occurred.

    Callers must not call grpc_completion_queue_next and
    grpc_completion_queue_pluck simultaneously on the same completion queue. */
    grpc_event grpc_completion_queue_next(grpc_completion_queue*, gpr_timespec, void*) @nogc nothrow;
    /** Create a completion queue */
    grpc_completion_queue* grpc_completion_queue_create(const(grpc_completion_queue_factory)*, const(grpc_completion_queue_attributes)*, void*) @nogc nothrow;
    /** Helper function to create a completion queue with grpc_cq_completion_type
    of GRPC_CQ_CALLBACK and grpc_cq_polling_type of GRPC_CQ_DEFAULT_POLLING.
    This function is experimental. */
    grpc_completion_queue* grpc_completion_queue_create_for_callback(grpc_completion_queue_functor*, void*) @nogc nothrow;
    /** Helper function to create a completion queue with grpc_cq_completion_type
    of GRPC_CQ_PLUCK and grpc_cq_polling_type of GRPC_CQ_DEFAULT_POLLING */
    grpc_completion_queue* grpc_completion_queue_create_for_pluck(void*) @nogc nothrow;
    /** Helper function to create a completion queue with grpc_cq_completion_type
    of GRPC_CQ_NEXT and grpc_cq_polling_type of GRPC_CQ_DEFAULT_POLLING */
    grpc_completion_queue* grpc_completion_queue_create_for_next(void*) @nogc nothrow;
    /** Returns the completion queue factory based on the attributes. MAY return a
    NULL if no factory can be found */
    const(grpc_completion_queue_factory)* grpc_completion_queue_factory_lookup(const(grpc_completion_queue_attributes)*) @nogc nothrow;
    /** Return a string specifying what the 'g' in gRPC stands for */
    const(char)* grpc_g_stands_for() @nogc nothrow;
    /** Return a string representing the current version of grpc */
    const(char)* grpc_version_string() @nogc nothrow;
    /** DEPRECATED. Recommend to use grpc_shutdown only */
    void grpc_shutdown_blocking() @nogc nothrow;
    /** EXPERIMENTAL. Returns 1 if the grpc library has been initialized.
    TODO(ericgribkoff) Decide if this should be promoted to non-experimental as
    part of stabilizing the fork support API, as tracked in
    https://github.com/grpc/grpc/issues/15334 */
    int grpc_is_initialized() @nogc nothrow;
    /** Shut down the grpc library.

    Before it's called, there should haven been a matching invocation to
    grpc_init().

    The last call to grpc_shutdown will initiate cleaning up of grpc library
    internals, which can happen in another thread. Once the clean-up is done,
    no memory is used by grpc, nor are any instructions executing within the
    grpc library.  Prior to calling, all application owned grpc objects must
    have been destroyed. */
    void grpc_shutdown() @nogc nothrow;
    /** Initialize the grpc library.

    After it's called, a matching invocation to grpc_shutdown() is expected.

    It is not safe to call any other grpc functions before calling this.
    (To avoid overhead, little checking is done, and some things may work. We
    do not warrant that they will continue to do so in future revisions of this
    library). */
    void grpc_init() @nogc nothrow;
    
    void grpc_call_details_destroy(grpc_call_details*) @nogc nothrow;
    
    void grpc_call_details_init(grpc_call_details*) @nogc nothrow;
    
    void grpc_metadata_array_destroy(grpc_metadata_array*) @nogc nothrow;
    /*! \mainpage GRPC Core
 *
 * The GRPC Core library is a low-level library designed to be wrapped by higher
 * level libraries. The top-level API is provided in grpc.h. Security related
 * functionality lives in grpc_security.h.
 */
    void grpc_metadata_array_init(grpc_metadata_array*) @nogc nothrow;
    /** Returns a RAW byte buffer instance from the output of \a reader. */
    grpc_byte_buffer* grpc_raw_byte_buffer_from_reader(grpc_byte_buffer_reader*) @nogc nothrow;
    /** Merge all data from \a reader into single slice */
    grpc_slice grpc_byte_buffer_reader_readall(grpc_byte_buffer_reader*) @nogc nothrow;
    /** EXPERIMENTAL API - This function may be removed and changed, in the future.
 *
 * Updates \a slice with the next piece of data from from \a reader and returns
 * 1. Returns 0 at the end of the stream. Caller is responsible for making sure
 * the slice pointer remains valid when accessed.
 *
 * NOTE: Do not use this function unless the caller can guarantee that the
 *       underlying grpc_byte_buffer outlasts the use of the slice. This is only
 *       safe when the underlying grpc_byte_buffer remains immutable while slice
 *       is being accessed. */
    int grpc_byte_buffer_reader_peek(grpc_byte_buffer_reader*, grpc_slice**) @nogc nothrow;
    /** Updates \a slice with the next piece of data from from \a reader and returns
 * 1. Returns 0 at the end of the stream. Caller is responsible for calling
 * grpc_slice_unref on the result. */
    int grpc_byte_buffer_reader_next(grpc_byte_buffer_reader*, grpc_slice*) @nogc nothrow;
    /** Cleanup and destroy \a reader */
    void grpc_byte_buffer_reader_destroy(grpc_byte_buffer_reader*) @nogc nothrow;
    /** Initialize \a reader to read over \a buffer.
 * Returns 1 upon success, 0 otherwise. */
    int grpc_byte_buffer_reader_init(grpc_byte_buffer_reader*, grpc_byte_buffer*) @nogc nothrow;
    /** Reader for byte buffers. Iterates over slices in the byte buffer */
    struct grpc_byte_buffer_reader
    {
        
        grpc_byte_buffer* buffer_in;
        
        grpc_byte_buffer* buffer_out;
        /** Different current objects correspond to different types of byte buffers */
        union grpc_byte_buffer_reader_current
        {
            /** Index into a slice buffer's array of slices */
            uint index;
        }
        
        grpc_byte_buffer_reader_current current;
    }
    /** Destroys \a byte_buffer deallocating all its memory. */
    void grpc_byte_buffer_destroy(grpc_byte_buffer*) @nogc nothrow;
    /** Returns the size of the given byte buffer, in bytes. */
    size_t grpc_byte_buffer_length(grpc_byte_buffer*) @nogc nothrow;
    /** Copies input byte buffer \a bb.
 *
 * Increases the reference count of all the source slices. The user is
 * responsible for calling grpc_byte_buffer_destroy over the returned copy. */
    grpc_byte_buffer* grpc_byte_buffer_copy(grpc_byte_buffer*) @nogc nothrow;
    /** Returns a *compressed* RAW byte buffer instance over the given slices (up to
 * \a nslices). The \a compression argument defines the compression algorithm
 * used to generate the data in \a slices.
 *
 * Increases the reference count for all \a slices processed. The user is
 * responsible for invoking grpc_byte_buffer_destroy on the returned instance.*/
    grpc_byte_buffer* grpc_raw_compressed_byte_buffer_create(grpc_slice*, size_t, grpc_compression_algorithm) @nogc nothrow;
    /** Returns a RAW byte buffer instance over the given slices (up to \a nslices).
 *
 * Increases the reference count for all \a slices processed. The user is
 * responsible for invoking grpc_byte_buffer_destroy on the returned instance.*/
    grpc_byte_buffer* grpc_raw_byte_buffer_create(grpc_slice*, size_t) @nogc nothrow;
    
    alias wchar_t = int;
    
    alias rsize_t = c_ulong;
    
    alias size_t = c_ulong;
    
    alias ptrdiff_t = c_long;
    
    alias max_align_t = real;
    
    int timespec_get(timespec*, int) @nogc nothrow;
    
    int clock_settime(clockid_t, const(timespec)*) @nogc nothrow;
    
    __uint64_t clock_gettime_nsec_np(clockid_t) @nogc nothrow;
    
    int clock_gettime(clockid_t, timespec*) @nogc nothrow;
    
    int clock_getres(clockid_t, timespec*) @nogc nothrow;
    
    enum clockid_t
    {
        
        _CLOCK_REALTIME = 0, 
        
        _CLOCK_MONOTONIC = 6, 
        
        _CLOCK_MONOTONIC_RAW = 4, 
        
        _CLOCK_MONOTONIC_RAW_APPROX = 5, 
        
        _CLOCK_UPTIME_RAW = 8, 
        
        _CLOCK_UPTIME_RAW_APPROX = 9, 
        
        _CLOCK_PROCESS_CPUTIME_ID = 12, 
        
        _CLOCK_THREAD_CPUTIME_ID = 16, 
    }
    enum _CLOCK_REALTIME = clockid_t._CLOCK_REALTIME;
    enum _CLOCK_MONOTONIC = clockid_t._CLOCK_MONOTONIC;
    enum _CLOCK_MONOTONIC_RAW = clockid_t._CLOCK_MONOTONIC_RAW;
    enum _CLOCK_MONOTONIC_RAW_APPROX = clockid_t._CLOCK_MONOTONIC_RAW_APPROX;
    enum _CLOCK_UPTIME_RAW = clockid_t._CLOCK_UPTIME_RAW;
    enum _CLOCK_UPTIME_RAW_APPROX = clockid_t._CLOCK_UPTIME_RAW_APPROX;
    enum _CLOCK_PROCESS_CPUTIME_ID = clockid_t._CLOCK_PROCESS_CPUTIME_ID;
    enum _CLOCK_THREAD_CPUTIME_ID = clockid_t._CLOCK_THREAD_CPUTIME_ID;
    
    int nanosleep(const(timespec)*, timespec*) @nogc nothrow;
    
    time_t timegm(tm*) @nogc nothrow;
    
    time_t timelocal(tm*) @nogc nothrow;
    
    time_t time2posix(time_t) @nogc nothrow;
    
    void tzsetwall() @nogc nothrow;
    
    time_t posix2time(time_t) @nogc nothrow;
    
    tm* localtime_r(const(time_t)*, tm*) @nogc nothrow;
    
    tm* gmtime_r(const(time_t)*, tm*) @nogc nothrow;
    
    char* ctime_r(const(time_t)*, char*) @nogc nothrow;
    
    char* asctime_r(const(tm)*, char*) @nogc nothrow;
    
    void tzset() @nogc nothrow;
    
    time_t time(time_t*) @nogc nothrow;
    
    char* strptime(const(char)*, const(char)*, tm*) @nogc nothrow;
    
    size_t strftime(char*, size_t, const(char)*, const(tm)*) @nogc nothrow;
    
    time_t mktime(tm*) @nogc nothrow;
    
    tm* localtime(const(time_t)*) @nogc nothrow;
    
    tm* gmtime(const(time_t)*) @nogc nothrow;
    
    tm* getdate(const(char)*) @nogc nothrow;
    
    double difftime(time_t, time_t) @nogc nothrow;
    
    char* ctime(const(time_t)*) @nogc nothrow;
    
    clock_t clock() @nogc nothrow;
    
    char* asctime(const(tm)*) @nogc nothrow;
    
    extern export __gshared int daylight;
    
    extern export __gshared c_long timezone;
    
    extern export __gshared int getdate_err;
    
    extern export __gshared char*[0] tzname;
    
    struct tm
    {
        
        int tm_sec;
        
        int tm_min;
        
        int tm_hour;
        
        int tm_mday;
        
        int tm_mon;
        
        int tm_year;
        
        int tm_wday;
        
        int tm_yday;
        
        int tm_isdst;
        
        c_long tm_gmtoff;
        
        char* tm_zone;
    }
    
    pid_t wait4(pid_t, int*, int, rusage*) @nogc nothrow;
    
    pid_t wait3(int*, int, rusage*) @nogc nothrow;
    
    int waitid(idtype_t, id_t, siginfo_t*, int) @nogc nothrow;
    
    pid_t waitpid(pid_t, int*, int) @nogc nothrow;
    pragma(mangle, "_wait")     
    pid_t wait_(int*) @nogc nothrow;
    
    union wait
    {
        
        int w_status;
        
        static struct _Anonymous_3
        {
            import std.bitmanip: bitfields;
        
            align(4):
            mixin(bitfields!(
            
                uint, "w_Termsig", 7,
            
                uint, "w_Coredump", 1,
            
                uint, "w_Retcode", 8,
            
                uint, "w_Filler", 16,
            ));
        }
        
        _Anonymous_3 w_T;
        
        static struct _Anonymous_4
        {
            import std.bitmanip: bitfields;
        
            align(4):
            mixin(bitfields!(
            
                uint, "w_Stopval", 8,
            
                uint, "w_Stopsig", 8,
            
                uint, "w_Filler", 16,
            ));
        }
        
        _Anonymous_4 w_S;
    }
    
    enum idtype_t
    {
        
        P_ALL = 0, 
        
        P_PID = 1, 
        
        P_PGID = 2, 
    }
    enum P_ALL = idtype_t.P_ALL;
    enum P_PID = idtype_t.P_PID;
    enum P_PGID = idtype_t.P_PGID;
    
    void function(int) signal(int, void function(int)) @nogc nothrow;
    
    struct sigstack
    {
        
        char* ss_sp;
        
        int ss_onstack;
    }
    
    struct sigvec
    {
        
        void function(int) sv_handler;
        
        int sv_mask;
        
        int sv_flags;
    }
    alias sig_t = void function(int);
    
    struct sigaction
    {
        
        __sigaction_u __sigaction_u_;
        
        sigset_t sa_mask;
        
        int sa_flags;
    }
    
    struct __sigaction
    {
        
        __sigaction_u __sigaction_u_;
        
        void function(void*, int, int, siginfo_t*, void*) sa_tramp;
        
        sigset_t sa_mask;
        
        int sa_flags;
    }
    
    union __sigaction_u
    {
        
        void function(int) __sa_handler;
        
        void function(int, __siginfo*, void*) __sa_sigaction;
    }
    
    struct __siginfo
    {
        
        int si_signo;
        
        int si_errno;
        
        int si_code;
        
        pid_t si_pid;
        
        uid_t si_uid;
        
        int si_status;
        
        void* si_addr;
        
        sigval si_value;
        
        c_long si_band;
        
        c_ulong[7] __pad;
    }
    
    alias siginfo_t = __siginfo;
    
    struct sigevent
    {
        
        int sigev_notify;
        
        int sigev_signo;
        
        sigval sigev_value;
        
        void function(sigval) sigev_notify_function;
        
        pthread_attr_t* sigev_notify_attributes;
    }
    
    union sigval
    {
        
        int sival_int;
        
        void* sival_ptr;
    }
    
    int setrlimit(int, const(rlimit)*) @nogc nothrow;
    
    int setiopolicy_np(int, int, int) @nogc nothrow;
    
    int setpriority(int, id_t, int) @nogc nothrow;
    
    int getrusage(int, rusage*) @nogc nothrow;
    
    int getrlimit(int, rlimit*) @nogc nothrow;
    
    int getiopolicy_np(int, int) @nogc nothrow;
    
    int getpriority(int, id_t) @nogc nothrow;
    
    struct proc_rlimit_control_wakeupmon
    {
        
        uint32_t wm_flags;
        
        int32_t wm_rate;
    }
    
    struct rlimit
    {
        
        rlim_t rlim_cur;
        
        rlim_t rlim_max;
    }
    
    alias rusage_info_current = rusage_info_v6;
    
    struct rusage_info_v6
    {
        
        uint8_t[16] ri_uuid;
        
        uint64_t ri_user_time;
        
        uint64_t ri_system_time;
        
        uint64_t ri_pkg_idle_wkups;
        
        uint64_t ri_interrupt_wkups;
        
        uint64_t ri_pageins;
        
        uint64_t ri_wired_size;
        
        uint64_t ri_resident_size;
        
        uint64_t ri_phys_footprint;
        
        uint64_t ri_proc_start_abstime;
        
        uint64_t ri_proc_exit_abstime;
        
        uint64_t ri_child_user_time;
        
        uint64_t ri_child_system_time;
        
        uint64_t ri_child_pkg_idle_wkups;
        
        uint64_t ri_child_interrupt_wkups;
        
        uint64_t ri_child_pageins;
        
        uint64_t ri_child_elapsed_abstime;
        
        uint64_t ri_diskio_bytesread;
        
        uint64_t ri_diskio_byteswritten;
        
        uint64_t ri_cpu_time_qos_default;
        
        uint64_t ri_cpu_time_qos_maintenance;
        
        uint64_t ri_cpu_time_qos_background;
        
        uint64_t ri_cpu_time_qos_utility;
        
        uint64_t ri_cpu_time_qos_legacy;
        
        uint64_t ri_cpu_time_qos_user_initiated;
        
        uint64_t ri_cpu_time_qos_user_interactive;
        
        uint64_t ri_billed_system_time;
        
        uint64_t ri_serviced_system_time;
        
        uint64_t ri_logical_writes;
        
        uint64_t ri_lifetime_max_phys_footprint;
        
        uint64_t ri_instructions;
        
        uint64_t ri_cycles;
        
        uint64_t ri_billed_energy;
        
        uint64_t ri_serviced_energy;
        
        uint64_t ri_interval_max_phys_footprint;
        
        uint64_t ri_runnable_time;
        
        uint64_t ri_flags;
        
        uint64_t ri_user_ptime;
        
        uint64_t ri_system_ptime;
        
        uint64_t ri_pinstructions;
        
        uint64_t ri_pcycles;
        
        uint64_t ri_energy_nj;
        
        uint64_t ri_penergy_nj;
        
        uint64_t[14] ri_reserved;
    }
    
    struct rusage_info_v5
    {
        
        uint8_t[16] ri_uuid;
        
        uint64_t ri_user_time;
        
        uint64_t ri_system_time;
        
        uint64_t ri_pkg_idle_wkups;
        
        uint64_t ri_interrupt_wkups;
        
        uint64_t ri_pageins;
        
        uint64_t ri_wired_size;
        
        uint64_t ri_resident_size;
        
        uint64_t ri_phys_footprint;
        
        uint64_t ri_proc_start_abstime;
        
        uint64_t ri_proc_exit_abstime;
        
        uint64_t ri_child_user_time;
        
        uint64_t ri_child_system_time;
        
        uint64_t ri_child_pkg_idle_wkups;
        
        uint64_t ri_child_interrupt_wkups;
        
        uint64_t ri_child_pageins;
        
        uint64_t ri_child_elapsed_abstime;
        
        uint64_t ri_diskio_bytesread;
        
        uint64_t ri_diskio_byteswritten;
        
        uint64_t ri_cpu_time_qos_default;
        
        uint64_t ri_cpu_time_qos_maintenance;
        
        uint64_t ri_cpu_time_qos_background;
        
        uint64_t ri_cpu_time_qos_utility;
        
        uint64_t ri_cpu_time_qos_legacy;
        
        uint64_t ri_cpu_time_qos_user_initiated;
        
        uint64_t ri_cpu_time_qos_user_interactive;
        
        uint64_t ri_billed_system_time;
        
        uint64_t ri_serviced_system_time;
        
        uint64_t ri_logical_writes;
        
        uint64_t ri_lifetime_max_phys_footprint;
        
        uint64_t ri_instructions;
        
        uint64_t ri_cycles;
        
        uint64_t ri_billed_energy;
        
        uint64_t ri_serviced_energy;
        
        uint64_t ri_interval_max_phys_footprint;
        
        uint64_t ri_runnable_time;
        
        uint64_t ri_flags;
    }
    
    struct rusage_info_v4
    {
        
        uint8_t[16] ri_uuid;
        
        uint64_t ri_user_time;
        
        uint64_t ri_system_time;
        
        uint64_t ri_pkg_idle_wkups;
        
        uint64_t ri_interrupt_wkups;
        
        uint64_t ri_pageins;
        
        uint64_t ri_wired_size;
        
        uint64_t ri_resident_size;
        
        uint64_t ri_phys_footprint;
        
        uint64_t ri_proc_start_abstime;
        
        uint64_t ri_proc_exit_abstime;
        
        uint64_t ri_child_user_time;
        
        uint64_t ri_child_system_time;
        
        uint64_t ri_child_pkg_idle_wkups;
        
        uint64_t ri_child_interrupt_wkups;
        
        uint64_t ri_child_pageins;
        
        uint64_t ri_child_elapsed_abstime;
        
        uint64_t ri_diskio_bytesread;
        
        uint64_t ri_diskio_byteswritten;
        
        uint64_t ri_cpu_time_qos_default;
        
        uint64_t ri_cpu_time_qos_maintenance;
        
        uint64_t ri_cpu_time_qos_background;
        
        uint64_t ri_cpu_time_qos_utility;
        
        uint64_t ri_cpu_time_qos_legacy;
        
        uint64_t ri_cpu_time_qos_user_initiated;
        
        uint64_t ri_cpu_time_qos_user_interactive;
        
        uint64_t ri_billed_system_time;
        
        uint64_t ri_serviced_system_time;
        
        uint64_t ri_logical_writes;
        
        uint64_t ri_lifetime_max_phys_footprint;
        
        uint64_t ri_instructions;
        
        uint64_t ri_cycles;
        
        uint64_t ri_billed_energy;
        
        uint64_t ri_serviced_energy;
        
        uint64_t ri_interval_max_phys_footprint;
        
        uint64_t ri_runnable_time;
    }
    
    struct rusage_info_v3
    {
        
        uint8_t[16] ri_uuid;
        
        uint64_t ri_user_time;
        
        uint64_t ri_system_time;
        
        uint64_t ri_pkg_idle_wkups;
        
        uint64_t ri_interrupt_wkups;
        
        uint64_t ri_pageins;
        
        uint64_t ri_wired_size;
        
        uint64_t ri_resident_size;
        
        uint64_t ri_phys_footprint;
        
        uint64_t ri_proc_start_abstime;
        
        uint64_t ri_proc_exit_abstime;
        
        uint64_t ri_child_user_time;
        
        uint64_t ri_child_system_time;
        
        uint64_t ri_child_pkg_idle_wkups;
        
        uint64_t ri_child_interrupt_wkups;
        
        uint64_t ri_child_pageins;
        
        uint64_t ri_child_elapsed_abstime;
        
        uint64_t ri_diskio_bytesread;
        
        uint64_t ri_diskio_byteswritten;
        
        uint64_t ri_cpu_time_qos_default;
        
        uint64_t ri_cpu_time_qos_maintenance;
        
        uint64_t ri_cpu_time_qos_background;
        
        uint64_t ri_cpu_time_qos_utility;
        
        uint64_t ri_cpu_time_qos_legacy;
        
        uint64_t ri_cpu_time_qos_user_initiated;
        
        uint64_t ri_cpu_time_qos_user_interactive;
        
        uint64_t ri_billed_system_time;
        
        uint64_t ri_serviced_system_time;
    }
    
    struct rusage_info_v2
    {
        
        uint8_t[16] ri_uuid;
        
        uint64_t ri_user_time;
        
        uint64_t ri_system_time;
        
        uint64_t ri_pkg_idle_wkups;
        
        uint64_t ri_interrupt_wkups;
        
        uint64_t ri_pageins;
        
        uint64_t ri_wired_size;
        
        uint64_t ri_resident_size;
        
        uint64_t ri_phys_footprint;
        
        uint64_t ri_proc_start_abstime;
        
        uint64_t ri_proc_exit_abstime;
        
        uint64_t ri_child_user_time;
        
        uint64_t ri_child_system_time;
        
        uint64_t ri_child_pkg_idle_wkups;
        
        uint64_t ri_child_interrupt_wkups;
        
        uint64_t ri_child_pageins;
        
        uint64_t ri_child_elapsed_abstime;
        
        uint64_t ri_diskio_bytesread;
        
        uint64_t ri_diskio_byteswritten;
    }
    
    struct rusage_info_v1
    {
        
        uint8_t[16] ri_uuid;
        
        uint64_t ri_user_time;
        
        uint64_t ri_system_time;
        
        uint64_t ri_pkg_idle_wkups;
        
        uint64_t ri_interrupt_wkups;
        
        uint64_t ri_pageins;
        
        uint64_t ri_wired_size;
        
        uint64_t ri_resident_size;
        
        uint64_t ri_phys_footprint;
        
        uint64_t ri_proc_start_abstime;
        
        uint64_t ri_proc_exit_abstime;
        
        uint64_t ri_child_user_time;
        
        uint64_t ri_child_system_time;
        
        uint64_t ri_child_pkg_idle_wkups;
        
        uint64_t ri_child_interrupt_wkups;
        
        uint64_t ri_child_pageins;
        
        uint64_t ri_child_elapsed_abstime;
    }
    
    struct rusage_info_v0
    {
        
        uint8_t[16] ri_uuid;
        
        uint64_t ri_user_time;
        
        uint64_t ri_system_time;
        
        uint64_t ri_pkg_idle_wkups;
        
        uint64_t ri_interrupt_wkups;
        
        uint64_t ri_pageins;
        
        uint64_t ri_wired_size;
        
        uint64_t ri_resident_size;
        
        uint64_t ri_phys_footprint;
        
        uint64_t ri_proc_start_abstime;
        
        uint64_t ri_proc_exit_abstime;
    }
    
    alias rusage_info_t = void*;
    
    struct rusage
    {
        
        timeval ru_utime;
        
        timeval ru_stime;
        
        c_long ru_maxrss;
        
        c_long ru_ixrss;
        
        c_long ru_idrss;
        
        c_long ru_isrss;
        
        c_long ru_minflt;
        
        c_long ru_majflt;
        
        c_long ru_nswap;
        
        c_long ru_inblock;
        
        c_long ru_oublock;
        
        c_long ru_msgsnd;
        
        c_long ru_msgrcv;
        
        c_long ru_nsignals;
        
        c_long ru_nvcsw;
        
        c_long ru_nivcsw;
    }
    
    alias rlim_t = __uint64_t;
    
    qos_class_t qos_class_main() @nogc nothrow;
    
    qos_class_t qos_class_self() @nogc nothrow;
    
    enum _Anonymous_5
    {
        
        QOS_CLASS_USER_INTERACTIVE = 33, 
        
        QOS_CLASS_USER_INITIATED = 25, 
        
        QOS_CLASS_DEFAULT = 21, 
        
        QOS_CLASS_UTILITY = 17, 
        
        QOS_CLASS_BACKGROUND = 9, 
        
        QOS_CLASS_UNSPECIFIED = 0, 
    }
    enum QOS_CLASS_USER_INTERACTIVE = _Anonymous_5.QOS_CLASS_USER_INTERACTIVE;
    enum QOS_CLASS_USER_INITIATED = _Anonymous_5.QOS_CLASS_USER_INITIATED;
    enum QOS_CLASS_DEFAULT = _Anonymous_5.QOS_CLASS_DEFAULT;
    enum QOS_CLASS_UTILITY = _Anonymous_5.QOS_CLASS_UTILITY;
    enum QOS_CLASS_BACKGROUND = _Anonymous_5.QOS_CLASS_BACKGROUND;
    enum QOS_CLASS_UNSPECIFIED = _Anonymous_5.QOS_CLASS_UNSPECIFIED;
    
    alias qos_class_t = uint;
    
    alias uintptr_t = c_ulong;
    
    alias uid_t = __darwin_uid_t;
    
    alias ucontext_t = __darwin_ucontext;
    
    struct __darwin_ucontext
    {
        
        int uc_onstack;
        
        __darwin_sigset_t uc_sigmask;
        
        __darwin_sigaltstack uc_stack;
        
        __darwin_ucontext* uc_link;
        
        __darwin_size_t uc_mcsize;
        
        __darwin_mcontext64* uc_mcontext;
    }
    
    alias u_int8_t = ubyte;
    
    alias u_int64_t = ulong;
    
    alias u_int32_t = uint;
    
    alias u_int16_t = ushort;
    
    struct timeval
    {
        
        __darwin_time_t tv_sec;
        
        __darwin_suseconds_t tv_usec;
    }
    
    struct timespec
    {
        
        __darwin_time_t tv_sec;
        
        c_long tv_nsec;
    }
    
    alias time_t = __darwin_time_t;
    
    alias sigset_t = __darwin_sigset_t;
    
    alias stack_t = __darwin_sigaltstack;
    
    struct __darwin_sigaltstack
    {
        
        void* ss_sp;
        
        __darwin_size_t ss_size;
        
        int ss_flags;
    }
    
    alias rune_t = __darwin_rune_t;
    
    alias pid_t = __darwin_pid_t;
    
    alias mode_t = __darwin_mode_t;
    
    alias mach_port_t = __darwin_mach_port_t;
    
    alias intptr_t = __darwin_intptr_t;
    
    alias int8_t = byte;
    
    alias int64_t = long;
    
    alias int32_t = int;
    
    alias int16_t = short;
    
    alias id_t = __darwin_id_t;
    
    alias dev_t = __darwin_dev_t;
    
    alias ct_rune_t = __darwin_ct_rune_t;
    
    alias clock_t = __darwin_clock_t;
    
    alias __darwin_uuid_string_t = char[37];
    
    alias __darwin_uuid_t = ubyte[16];
    
    alias __darwin_useconds_t = __uint32_t;
    
    alias __darwin_uid_t = __uint32_t;
    
    alias __darwin_suseconds_t = __int32_t;
    
    alias __darwin_sigset_t = __uint32_t;
    
    alias __darwin_pid_t = __int32_t;
    
    alias __darwin_off_t = __int64_t;
    
    alias __darwin_mode_t = __uint16_t;
    
    alias __darwin_mach_port_t = __darwin_mach_port_name_t;
    
    alias __darwin_mach_port_name_t = __darwin_natural_t;
    
    alias __darwin_ino_t = __darwin_ino64_t;
    
    alias __darwin_ino64_t = __uint64_t;
    
    alias __darwin_id_t = __uint32_t;
    
    alias __darwin_gid_t = __uint32_t;
    
    alias __darwin_fsfilcnt_t = uint;
    
    alias __darwin_fsblkcnt_t = uint;
    
    alias __darwin_dev_t = __int32_t;
    
    alias __darwin_blksize_t = __int32_t;
    
    alias __darwin_blkcnt_t = __int64_t;
    
    alias __darwin_pthread_t = _opaque_pthread_t*;
    
    alias __darwin_pthread_rwlockattr_t = _opaque_pthread_rwlockattr_t;
    
    alias __darwin_pthread_rwlock_t = _opaque_pthread_rwlock_t;
    
    alias __darwin_pthread_once_t = _opaque_pthread_once_t;
    
    alias __darwin_pthread_mutexattr_t = _opaque_pthread_mutexattr_t;
    
    alias __darwin_pthread_mutex_t = _opaque_pthread_mutex_t;
    
    alias __darwin_pthread_key_t = c_ulong;
    
    alias __darwin_pthread_condattr_t = _opaque_pthread_condattr_t;
    
    alias __darwin_pthread_cond_t = _opaque_pthread_cond_t;
    
    alias __darwin_pthread_attr_t = _opaque_pthread_attr_t;
    
    struct _opaque_pthread_t
    {
        
        c_long __sig;
        
        __darwin_pthread_handler_rec* __cleanup_stack;
        
        char[8176] __opaque;
    }
    
    struct _opaque_pthread_rwlockattr_t
    {
        
        c_long __sig;
        
        char[16] __opaque;
    }
    
    struct _opaque_pthread_rwlock_t
    {
        
        c_long __sig;
        
        char[192] __opaque;
    }
    
    struct _opaque_pthread_once_t
    {
        
        c_long __sig;
        
        char[8] __opaque;
    }
    
    struct _opaque_pthread_mutexattr_t
    {
        
        c_long __sig;
        
        char[8] __opaque;
    }
    
    struct _opaque_pthread_mutex_t
    {
        
        c_long __sig;
        
        char[56] __opaque;
    }
    
    struct _opaque_pthread_condattr_t
    {
        
        c_long __sig;
        
        char[8] __opaque;
    }
    
    struct _opaque_pthread_cond_t
    {
        
        c_long __sig;
        
        char[40] __opaque;
    }
    
    struct _opaque_pthread_attr_t
    {
        
        c_long __sig;
        
        char[56] __opaque;
    }
    
    struct __darwin_pthread_handler_rec
    {
        
        void function(void*) __routine;
        
        void* __arg;
        
        __darwin_pthread_handler_rec* __next;
    }
    
    alias pthread_t = __darwin_pthread_t;
    
    alias pthread_rwlockattr_t = __darwin_pthread_rwlockattr_t;
    
    alias pthread_rwlock_t = __darwin_pthread_rwlock_t;
    
    alias pthread_once_t = __darwin_pthread_once_t;
    
    alias pthread_mutexattr_t = __darwin_pthread_mutexattr_t;
    
    alias pthread_mutex_t = __darwin_pthread_mutex_t;
    
    alias __darwin_nl_item = int;
    
    alias __darwin_wctrans_t = int;
    
    alias __darwin_wctype_t = __uint32_t;
    
    alias pthread_key_t = __darwin_pthread_key_t;
    
    alias pthread_condattr_t = __darwin_pthread_condattr_t;
    
    alias pthread_cond_t = __darwin_pthread_cond_t;
    
    alias intmax_t = c_long;
    
    alias uint16_t = ushort;
    
    alias pthread_attr_t = __darwin_pthread_attr_t;
    
    alias uint32_t = uint;
    
    alias uint64_t = ulong;
    
    alias uint8_t = ubyte;
    
    alias uintmax_t = c_ulong;
    
    void* alloca(c_ulong) @nogc nothrow;
    
    struct __darwin_mcontext32
    {
        
        __darwin_i386_exception_state __es;
        
        __darwin_i386_thread_state __ss;
        
        __darwin_i386_float_state __fs;
    }
    
    struct __darwin_mcontext_avx32
    {
        
        __darwin_i386_exception_state __es;
        
        __darwin_i386_thread_state __ss;
        
        __darwin_i386_avx_state __fs;
    }
    
    extern export __gshared char* suboptarg;
    
    struct __darwin_mcontext_avx512_32
    {
        
        __darwin_i386_exception_state __es;
        
        __darwin_i386_thread_state __ss;
        
        __darwin_i386_avx512_state __fs;
    }
    
    ulong strtouq(const(char)*, char**, int) @nogc nothrow;
    
    struct __darwin_mcontext64
    {
        
        __darwin_x86_exception_state64 __es;
        
        __darwin_x86_thread_state64 __ss;
        
        __darwin_x86_float_state64 __fs;
    }
    
    long strtoq(const(char)*, char**, int) @nogc nothrow;
    
    struct __darwin_mcontext64_full
    {
        
        __darwin_x86_exception_state64 __es;
        
        __darwin_x86_thread_full_state64 __ss;
        
        __darwin_x86_float_state64 __fs;
    }
    
    struct __darwin_mcontext_avx64
    {
        
        __darwin_x86_exception_state64 __es;
        
        __darwin_x86_thread_state64 __ss;
        
        __darwin_x86_avx_state64 __fs;
    }
    
    struct __darwin_mcontext_avx64_full
    {
        
        __darwin_x86_exception_state64 __es;
        
        __darwin_x86_thread_full_state64 __ss;
        
        __darwin_x86_avx_state64 __fs;
    }
    
    long strtonum(const(char)*, long, long, const(char)**) @nogc nothrow;
    
    struct __darwin_mcontext_avx512_64
    {
        
        __darwin_x86_exception_state64 __es;
        
        __darwin_x86_thread_state64 __ss;
        
        __darwin_x86_avx512_state64 __fs;
    }
    
    struct __darwin_mcontext_avx512_64_full
    {
        
        __darwin_x86_exception_state64 __es;
        
        __darwin_x86_thread_full_state64 __ss;
        
        __darwin_x86_avx512_state64 __fs;
    }
    
    void* reallocf(void*, size_t) @nogc nothrow;
    
    alias mcontext_t = __darwin_mcontext64*;
    
    void srandomdev() @nogc nothrow;
    
    void sranddev() @nogc nothrow;
    
    alias __int8_t = byte;
    
    alias __uint8_t = ubyte;
    
    alias __int16_t = short;
    
    alias __uint16_t = ushort;
    
    alias __int32_t = int;
    
    alias __uint32_t = uint;
    
    alias __int64_t = long;
    
    alias __uint64_t = ulong;
    
    alias __darwin_intptr_t = c_long;
    
    alias __darwin_natural_t = uint;
    
    alias __darwin_ct_rune_t = int;
    
    union __mbstate_t
    {
        
        char[128] __mbstate8;
        
        long _mbstateL;
    }
    
    alias __darwin_mbstate_t = __mbstate_t;
    
    alias __darwin_ptrdiff_t = c_long;
    
    alias __darwin_size_t = c_ulong;
    
    alias __darwin_va_list = __builtin_va_list;
    
    alias __darwin_wchar_t = int;
    
    alias __darwin_rune_t = __darwin_wchar_t;
    
    alias __darwin_wint_t = int;
    
    alias __darwin_clock_t = c_ulong;
    
    alias __darwin_socklen_t = __uint32_t;
    
    alias __darwin_ssize_t = c_long;
    
    alias __darwin_time_t = c_long;
    
    int sradixsort(const(ubyte)**, int, const(ubyte)*, uint) @nogc nothrow;
    
    int rpmatch(const(char)*) @nogc nothrow;
    
    int radixsort(const(ubyte)**, int, const(ubyte)*, uint) @nogc nothrow;
    
    void qsort_r(void*, size_t, size_t, void*, int function(void*, const(void)*, const(void)*)) @nogc nothrow;
    
    void psort_r(void*, size_t, size_t, void*, int function(void*, const(void)*, const(void)*)) @nogc nothrow;
    
    alias sig_atomic_t = int;
    
    alias register_t = int64_t;
    
    alias user_addr_t = u_int64_t;
    
    alias user_size_t = u_int64_t;
    
    alias user_ssize_t = int64_t;
    
    alias user_long_t = int64_t;
    
    alias user_ulong_t = u_int64_t;
    
    alias user_time_t = int64_t;
    
    alias user_off_t = int64_t;
    
    alias syscall_arg_t = u_int64_t;
    
    void psort(void*, size_t, size_t, int function(const(void)*, const(void)*)) @nogc nothrow;
    
    int mergesort(void*, size_t, size_t, int function(const(void)*, const(void)*)) @nogc nothrow;
    
    int heapsort(void*, size_t, size_t, int function(const(void)*, const(void)*)) @nogc nothrow;
    
    struct __darwin_i386_thread_state
    {
        
        uint __eax;
        
        uint __ebx;
        
        uint __ecx;
        
        uint __edx;
        
        uint __edi;
        
        uint __esi;
        
        uint __ebp;
        
        uint __esp;
        
        uint __ss;
        
        uint __eflags;
        
        uint __eip;
        
        uint __cs;
        
        uint __ds;
        
        uint __es;
        
        uint __fs;
        
        uint __gs;
    }
    
    struct __darwin_fp_control
    {
        import std.bitmanip: bitfields;
    
        align(4):
        mixin(bitfields!(
        
            ushort, "__invalid", 1,
        
            ushort, "__denorm", 1,
        
            ushort, "__zdiv", 1,
        
            ushort, "__ovrfl", 1,
        
            ushort, "__undfl", 1,
        
            ushort, "__precis", 1,
        
            ushort, "_anonymous_6", 2,
        
            ushort, "__pc", 2,
        
            ushort, "__rc", 2,
        
            ushort, "_anonymous_7", 1,
        
            ushort, "_anonymous_8", 3,
        ));
    }
    
    void setprogname(const(char)*) @nogc nothrow;
    
    const(char)* getprogname() @nogc nothrow;
    
    int getloadavg(double*, int) @nogc nothrow;
    
    char* getbsize(int*, c_long*) @nogc nothrow;
    
    char* devname_r(dev_t, mode_t, char*, int) @nogc nothrow;
    
    char* devname(dev_t, mode_t) @nogc nothrow;
    
    alias __darwin_fp_control_t = __darwin_fp_control;
    
    struct __darwin_fp_status
    {
        import std.bitmanip: bitfields;
    
        align(4):
        mixin(bitfields!(
        
            ushort, "__invalid", 1,
        
            ushort, "__denorm", 1,
        
            ushort, "__zdiv", 1,
        
            ushort, "__ovrfl", 1,
        
            ushort, "__undfl", 1,
        
            ushort, "__precis", 1,
        
            ushort, "__stkflt", 1,
        
            ushort, "__errsumm", 1,
        
            ushort, "__c0", 1,
        
            ushort, "__c1", 1,
        
            ushort, "__c2", 1,
        
            ushort, "__tos", 3,
        
            ushort, "__c3", 1,
        
            ushort, "__busy", 1,
        ));
    }
    
    alias __darwin_fp_status_t = __darwin_fp_status;
    
    struct __darwin_mmst_reg
    {
        
        char[10] __mmst_reg;
        
        char[6] __mmst_rsrv;
    }
    
    struct __darwin_xmm_reg
    {
        
        char[16] __xmm_reg;
    }
    
    struct __darwin_ymm_reg
    {
        
        char[32] __ymm_reg;
    }
    
    int daemon(int, int) @nogc nothrow;
    
    struct __darwin_zmm_reg
    {
        
        char[64] __zmm_reg;
    }
    
    int cgetustr(char*, const(char)*, char**) @nogc nothrow;
    
    struct __darwin_opmask_reg
    {
        
        char[8] __opmask_reg;
    }
    
    int cgetstr(char*, const(char)*, char**) @nogc nothrow;
    
    int cgetset(const(char)*) @nogc nothrow;
    
    struct __darwin_i386_float_state
    {
        
        int[2] __fpu_reserved;
        
        __darwin_fp_control __fpu_fcw;
        
        __darwin_fp_status __fpu_fsw;
        
        __uint8_t __fpu_ftw;
        
        __uint8_t __fpu_rsrv1;
        
        __uint16_t __fpu_fop;
        
        __uint32_t __fpu_ip;
        
        __uint16_t __fpu_cs;
        
        __uint16_t __fpu_rsrv2;
        
        __uint32_t __fpu_dp;
        
        __uint16_t __fpu_ds;
        
        __uint16_t __fpu_rsrv3;
        
        __uint32_t __fpu_mxcsr;
        
        __uint32_t __fpu_mxcsrmask;
        
        __darwin_mmst_reg __fpu_stmm0;
        
        __darwin_mmst_reg __fpu_stmm1;
        
        __darwin_mmst_reg __fpu_stmm2;
        
        __darwin_mmst_reg __fpu_stmm3;
        
        __darwin_mmst_reg __fpu_stmm4;
        
        __darwin_mmst_reg __fpu_stmm5;
        
        __darwin_mmst_reg __fpu_stmm6;
        
        __darwin_mmst_reg __fpu_stmm7;
        
        __darwin_xmm_reg __fpu_xmm0;
        
        __darwin_xmm_reg __fpu_xmm1;
        
        __darwin_xmm_reg __fpu_xmm2;
        
        __darwin_xmm_reg __fpu_xmm3;
        
        __darwin_xmm_reg __fpu_xmm4;
        
        __darwin_xmm_reg __fpu_xmm5;
        
        __darwin_xmm_reg __fpu_xmm6;
        
        __darwin_xmm_reg __fpu_xmm7;
        
        char[224] __fpu_rsrv4;
        
        int __fpu_reserved1;
    }
    
    int cgetnum(char*, const(char)*, c_long*) @nogc nothrow;
    
    struct __darwin_i386_avx_state
    {
        
        int[2] __fpu_reserved;
        
        __darwin_fp_control __fpu_fcw;
        
        __darwin_fp_status __fpu_fsw;
        
        __uint8_t __fpu_ftw;
        
        __uint8_t __fpu_rsrv1;
        
        __uint16_t __fpu_fop;
        
        __uint32_t __fpu_ip;
        
        __uint16_t __fpu_cs;
        
        __uint16_t __fpu_rsrv2;
        
        __uint32_t __fpu_dp;
        
        __uint16_t __fpu_ds;
        
        __uint16_t __fpu_rsrv3;
        
        __uint32_t __fpu_mxcsr;
        
        __uint32_t __fpu_mxcsrmask;
        
        __darwin_mmst_reg __fpu_stmm0;
        
        __darwin_mmst_reg __fpu_stmm1;
        
        __darwin_mmst_reg __fpu_stmm2;
        
        __darwin_mmst_reg __fpu_stmm3;
        
        __darwin_mmst_reg __fpu_stmm4;
        
        __darwin_mmst_reg __fpu_stmm5;
        
        __darwin_mmst_reg __fpu_stmm6;
        
        __darwin_mmst_reg __fpu_stmm7;
        
        __darwin_xmm_reg __fpu_xmm0;
        
        __darwin_xmm_reg __fpu_xmm1;
        
        __darwin_xmm_reg __fpu_xmm2;
        
        __darwin_xmm_reg __fpu_xmm3;
        
        __darwin_xmm_reg __fpu_xmm4;
        
        __darwin_xmm_reg __fpu_xmm5;
        
        __darwin_xmm_reg __fpu_xmm6;
        
        __darwin_xmm_reg __fpu_xmm7;
        
        char[224] __fpu_rsrv4;
        
        int __fpu_reserved1;
        
        char[64] __avx_reserved1;
        
        __darwin_xmm_reg __fpu_ymmh0;
        
        __darwin_xmm_reg __fpu_ymmh1;
        
        __darwin_xmm_reg __fpu_ymmh2;
        
        __darwin_xmm_reg __fpu_ymmh3;
        
        __darwin_xmm_reg __fpu_ymmh4;
        
        __darwin_xmm_reg __fpu_ymmh5;
        
        __darwin_xmm_reg __fpu_ymmh6;
        
        __darwin_xmm_reg __fpu_ymmh7;
    }
    
    int cgetnext(char**, char**) @nogc nothrow;
    
    struct __darwin_i386_avx512_state
    {
        
        int[2] __fpu_reserved;
        
        __darwin_fp_control __fpu_fcw;
        
        __darwin_fp_status __fpu_fsw;
        
        __uint8_t __fpu_ftw;
        
        __uint8_t __fpu_rsrv1;
        
        __uint16_t __fpu_fop;
        
        __uint32_t __fpu_ip;
        
        __uint16_t __fpu_cs;
        
        __uint16_t __fpu_rsrv2;
        
        __uint32_t __fpu_dp;
        
        __uint16_t __fpu_ds;
        
        __uint16_t __fpu_rsrv3;
        
        __uint32_t __fpu_mxcsr;
        
        __uint32_t __fpu_mxcsrmask;
        
        __darwin_mmst_reg __fpu_stmm0;
        
        __darwin_mmst_reg __fpu_stmm1;
        
        __darwin_mmst_reg __fpu_stmm2;
        
        __darwin_mmst_reg __fpu_stmm3;
        
        __darwin_mmst_reg __fpu_stmm4;
        
        __darwin_mmst_reg __fpu_stmm5;
        
        __darwin_mmst_reg __fpu_stmm6;
        
        __darwin_mmst_reg __fpu_stmm7;
        
        __darwin_xmm_reg __fpu_xmm0;
        
        __darwin_xmm_reg __fpu_xmm1;
        
        __darwin_xmm_reg __fpu_xmm2;
        
        __darwin_xmm_reg __fpu_xmm3;
        
        __darwin_xmm_reg __fpu_xmm4;
        
        __darwin_xmm_reg __fpu_xmm5;
        
        __darwin_xmm_reg __fpu_xmm6;
        
        __darwin_xmm_reg __fpu_xmm7;
        
        char[224] __fpu_rsrv4;
        
        int __fpu_reserved1;
        
        char[64] __avx_reserved1;
        
        __darwin_xmm_reg __fpu_ymmh0;
        
        __darwin_xmm_reg __fpu_ymmh1;
        
        __darwin_xmm_reg __fpu_ymmh2;
        
        __darwin_xmm_reg __fpu_ymmh3;
        
        __darwin_xmm_reg __fpu_ymmh4;
        
        __darwin_xmm_reg __fpu_ymmh5;
        
        __darwin_xmm_reg __fpu_ymmh6;
        
        __darwin_xmm_reg __fpu_ymmh7;
        
        __darwin_opmask_reg __fpu_k0;
        
        __darwin_opmask_reg __fpu_k1;
        
        __darwin_opmask_reg __fpu_k2;
        
        __darwin_opmask_reg __fpu_k3;
        
        __darwin_opmask_reg __fpu_k4;
        
        __darwin_opmask_reg __fpu_k5;
        
        __darwin_opmask_reg __fpu_k6;
        
        __darwin_opmask_reg __fpu_k7;
        
        __darwin_ymm_reg __fpu_zmmh0;
        
        __darwin_ymm_reg __fpu_zmmh1;
        
        __darwin_ymm_reg __fpu_zmmh2;
        
        __darwin_ymm_reg __fpu_zmmh3;
        
        __darwin_ymm_reg __fpu_zmmh4;
        
        __darwin_ymm_reg __fpu_zmmh5;
        
        __darwin_ymm_reg __fpu_zmmh6;
        
        __darwin_ymm_reg __fpu_zmmh7;
    }
    
    int cgetmatch(const(char)*, const(char)*) @nogc nothrow;
    
    struct __darwin_i386_exception_state
    {
        
        __uint16_t __trapno;
        
        __uint16_t __cpu;
        
        __uint32_t __err;
        
        __uint32_t __faultvaddr;
    }
    
    int cgetfirst(char**, char**) @nogc nothrow;
    
    struct __darwin_x86_debug_state32
    {
        
        uint __dr0;
        
        uint __dr1;
        
        uint __dr2;
        
        uint __dr3;
        
        uint __dr4;
        
        uint __dr5;
        
        uint __dr6;
        
        uint __dr7;
    }
    
    int cgetent(char**, char**, const(char)*) @nogc nothrow;
    
    struct __x86_instruction_state
    {
        
        int __insn_stream_valid_bytes;
        
        int __insn_offset;
        
        int __out_of_synch;
        
        __uint8_t[2380] __insn_bytes;
        
        __uint8_t[64] __insn_cacheline;
    }
    
    int cgetclose() @nogc nothrow;
    
    char* cgetcap(char*, const(char)*, int) @nogc nothrow;
    
    struct __last_branch_record
    {
        import std.bitmanip: bitfields;
    
        align(4):
        
        __uint64_t __from_ip;
        
        __uint64_t __to_ip;
        mixin(bitfields!(
        
            __uint32_t, "__mispredict", 1,
        
            __uint32_t, "__tsx_abort", 1,
        
            __uint32_t, "__in_tsx", 1,
        
            __uint32_t, "__cycle_count", 16,
        
            __uint32_t, "__reserved", 13,
        ));
    }
    
    struct __last_branch_state
    {
        import std.bitmanip: bitfields;
    
        align(4):
        
        int __lbr_count;
        mixin(bitfields!(
        
            __uint32_t, "__lbr_supported_tsx", 1,
        
            __uint32_t, "__lbr_supported_cycle_count", 1,
        
            __uint32_t, "__reserved", 30,
        ));
        
        __last_branch_record[32] __lbrs;
    }
    
    struct __x86_pagein_state
    {
        
        int __pagein_error;
    }
    
    struct __darwin_x86_thread_state64
    {
        
        __uint64_t __rax;
        
        __uint64_t __rbx;
        
        __uint64_t __rcx;
        
        __uint64_t __rdx;
        
        __uint64_t __rdi;
        
        __uint64_t __rsi;
        
        __uint64_t __rbp;
        
        __uint64_t __rsp;
        
        __uint64_t __r8;
        
        __uint64_t __r9;
        
        __uint64_t __r10;
        
        __uint64_t __r11;
        
        __uint64_t __r12;
        
        __uint64_t __r13;
        
        __uint64_t __r14;
        
        __uint64_t __r15;
        
        __uint64_t __rip;
        
        __uint64_t __rflags;
        
        __uint64_t __cs;
        
        __uint64_t __fs;
        
        __uint64_t __gs;
    }
    
    struct __darwin_x86_thread_full_state64
    {
        
        __darwin_x86_thread_state64 __ss64;
        
        __uint64_t __ds;
        
        __uint64_t __es;
        
        __uint64_t __ss;
        
        __uint64_t __gsbase;
    }
    
    struct __darwin_x86_float_state64
    {
        
        int[2] __fpu_reserved;
        
        __darwin_fp_control __fpu_fcw;
        
        __darwin_fp_status __fpu_fsw;
        
        __uint8_t __fpu_ftw;
        
        __uint8_t __fpu_rsrv1;
        
        __uint16_t __fpu_fop;
        
        __uint32_t __fpu_ip;
        
        __uint16_t __fpu_cs;
        
        __uint16_t __fpu_rsrv2;
        
        __uint32_t __fpu_dp;
        
        __uint16_t __fpu_ds;
        
        __uint16_t __fpu_rsrv3;
        
        __uint32_t __fpu_mxcsr;
        
        __uint32_t __fpu_mxcsrmask;
        
        __darwin_mmst_reg __fpu_stmm0;
        
        __darwin_mmst_reg __fpu_stmm1;
        
        __darwin_mmst_reg __fpu_stmm2;
        
        __darwin_mmst_reg __fpu_stmm3;
        
        __darwin_mmst_reg __fpu_stmm4;
        
        __darwin_mmst_reg __fpu_stmm5;
        
        __darwin_mmst_reg __fpu_stmm6;
        
        __darwin_mmst_reg __fpu_stmm7;
        
        __darwin_xmm_reg __fpu_xmm0;
        
        __darwin_xmm_reg __fpu_xmm1;
        
        __darwin_xmm_reg __fpu_xmm2;
        
        __darwin_xmm_reg __fpu_xmm3;
        
        __darwin_xmm_reg __fpu_xmm4;
        
        __darwin_xmm_reg __fpu_xmm5;
        
        __darwin_xmm_reg __fpu_xmm6;
        
        __darwin_xmm_reg __fpu_xmm7;
        
        __darwin_xmm_reg __fpu_xmm8;
        
        __darwin_xmm_reg __fpu_xmm9;
        
        __darwin_xmm_reg __fpu_xmm10;
        
        __darwin_xmm_reg __fpu_xmm11;
        
        __darwin_xmm_reg __fpu_xmm12;
        
        __darwin_xmm_reg __fpu_xmm13;
        
        __darwin_xmm_reg __fpu_xmm14;
        
        __darwin_xmm_reg __fpu_xmm15;
        
        char[96] __fpu_rsrv4;
        
        int __fpu_reserved1;
    }
    
    struct __darwin_x86_avx_state64
    {
        
        int[2] __fpu_reserved;
        
        __darwin_fp_control __fpu_fcw;
        
        __darwin_fp_status __fpu_fsw;
        
        __uint8_t __fpu_ftw;
        
        __uint8_t __fpu_rsrv1;
        
        __uint16_t __fpu_fop;
        
        __uint32_t __fpu_ip;
        
        __uint16_t __fpu_cs;
        
        __uint16_t __fpu_rsrv2;
        
        __uint32_t __fpu_dp;
        
        __uint16_t __fpu_ds;
        
        __uint16_t __fpu_rsrv3;
        
        __uint32_t __fpu_mxcsr;
        
        __uint32_t __fpu_mxcsrmask;
        
        __darwin_mmst_reg __fpu_stmm0;
        
        __darwin_mmst_reg __fpu_stmm1;
        
        __darwin_mmst_reg __fpu_stmm2;
        
        __darwin_mmst_reg __fpu_stmm3;
        
        __darwin_mmst_reg __fpu_stmm4;
        
        __darwin_mmst_reg __fpu_stmm5;
        
        __darwin_mmst_reg __fpu_stmm6;
        
        __darwin_mmst_reg __fpu_stmm7;
        
        __darwin_xmm_reg __fpu_xmm0;
        
        __darwin_xmm_reg __fpu_xmm1;
        
        __darwin_xmm_reg __fpu_xmm2;
        
        __darwin_xmm_reg __fpu_xmm3;
        
        __darwin_xmm_reg __fpu_xmm4;
        
        __darwin_xmm_reg __fpu_xmm5;
        
        __darwin_xmm_reg __fpu_xmm6;
        
        __darwin_xmm_reg __fpu_xmm7;
        
        __darwin_xmm_reg __fpu_xmm8;
        
        __darwin_xmm_reg __fpu_xmm9;
        
        __darwin_xmm_reg __fpu_xmm10;
        
        __darwin_xmm_reg __fpu_xmm11;
        
        __darwin_xmm_reg __fpu_xmm12;
        
        __darwin_xmm_reg __fpu_xmm13;
        
        __darwin_xmm_reg __fpu_xmm14;
        
        __darwin_xmm_reg __fpu_xmm15;
        
        char[96] __fpu_rsrv4;
        
        int __fpu_reserved1;
        
        char[64] __avx_reserved1;
        
        __darwin_xmm_reg __fpu_ymmh0;
        
        __darwin_xmm_reg __fpu_ymmh1;
        
        __darwin_xmm_reg __fpu_ymmh2;
        
        __darwin_xmm_reg __fpu_ymmh3;
        
        __darwin_xmm_reg __fpu_ymmh4;
        
        __darwin_xmm_reg __fpu_ymmh5;
        
        __darwin_xmm_reg __fpu_ymmh6;
        
        __darwin_xmm_reg __fpu_ymmh7;
        
        __darwin_xmm_reg __fpu_ymmh8;
        
        __darwin_xmm_reg __fpu_ymmh9;
        
        __darwin_xmm_reg __fpu_ymmh10;
        
        __darwin_xmm_reg __fpu_ymmh11;
        
        __darwin_xmm_reg __fpu_ymmh12;
        
        __darwin_xmm_reg __fpu_ymmh13;
        
        __darwin_xmm_reg __fpu_ymmh14;
        
        __darwin_xmm_reg __fpu_ymmh15;
    }
    
    struct __darwin_x86_avx512_state64
    {
        
        int[2] __fpu_reserved;
        
        __darwin_fp_control __fpu_fcw;
        
        __darwin_fp_status __fpu_fsw;
        
        __uint8_t __fpu_ftw;
        
        __uint8_t __fpu_rsrv1;
        
        __uint16_t __fpu_fop;
        
        __uint32_t __fpu_ip;
        
        __uint16_t __fpu_cs;
        
        __uint16_t __fpu_rsrv2;
        
        __uint32_t __fpu_dp;
        
        __uint16_t __fpu_ds;
        
        __uint16_t __fpu_rsrv3;
        
        __uint32_t __fpu_mxcsr;
        
        __uint32_t __fpu_mxcsrmask;
        
        __darwin_mmst_reg __fpu_stmm0;
        
        __darwin_mmst_reg __fpu_stmm1;
        
        __darwin_mmst_reg __fpu_stmm2;
        
        __darwin_mmst_reg __fpu_stmm3;
        
        __darwin_mmst_reg __fpu_stmm4;
        
        __darwin_mmst_reg __fpu_stmm5;
        
        __darwin_mmst_reg __fpu_stmm6;
        
        __darwin_mmst_reg __fpu_stmm7;
        
        __darwin_xmm_reg __fpu_xmm0;
        
        __darwin_xmm_reg __fpu_xmm1;
        
        __darwin_xmm_reg __fpu_xmm2;
        
        __darwin_xmm_reg __fpu_xmm3;
        
        __darwin_xmm_reg __fpu_xmm4;
        
        __darwin_xmm_reg __fpu_xmm5;
        
        __darwin_xmm_reg __fpu_xmm6;
        
        __darwin_xmm_reg __fpu_xmm7;
        
        __darwin_xmm_reg __fpu_xmm8;
        
        __darwin_xmm_reg __fpu_xmm9;
        
        __darwin_xmm_reg __fpu_xmm10;
        
        __darwin_xmm_reg __fpu_xmm11;
        
        __darwin_xmm_reg __fpu_xmm12;
        
        __darwin_xmm_reg __fpu_xmm13;
        
        __darwin_xmm_reg __fpu_xmm14;
        
        __darwin_xmm_reg __fpu_xmm15;
        
        char[96] __fpu_rsrv4;
        
        int __fpu_reserved1;
        
        char[64] __avx_reserved1;
        
        __darwin_xmm_reg __fpu_ymmh0;
        
        __darwin_xmm_reg __fpu_ymmh1;
        
        __darwin_xmm_reg __fpu_ymmh2;
        
        __darwin_xmm_reg __fpu_ymmh3;
        
        __darwin_xmm_reg __fpu_ymmh4;
        
        __darwin_xmm_reg __fpu_ymmh5;
        
        __darwin_xmm_reg __fpu_ymmh6;
        
        __darwin_xmm_reg __fpu_ymmh7;
        
        __darwin_xmm_reg __fpu_ymmh8;
        
        __darwin_xmm_reg __fpu_ymmh9;
        
        __darwin_xmm_reg __fpu_ymmh10;
        
        __darwin_xmm_reg __fpu_ymmh11;
        
        __darwin_xmm_reg __fpu_ymmh12;
        
        __darwin_xmm_reg __fpu_ymmh13;
        
        __darwin_xmm_reg __fpu_ymmh14;
        
        __darwin_xmm_reg __fpu_ymmh15;
        
        __darwin_opmask_reg __fpu_k0;
        
        __darwin_opmask_reg __fpu_k1;
        
        __darwin_opmask_reg __fpu_k2;
        
        __darwin_opmask_reg __fpu_k3;
        
        __darwin_opmask_reg __fpu_k4;
        
        __darwin_opmask_reg __fpu_k5;
        
        __darwin_opmask_reg __fpu_k6;
        
        __darwin_opmask_reg __fpu_k7;
        
        __darwin_ymm_reg __fpu_zmmh0;
        
        __darwin_ymm_reg __fpu_zmmh1;
        
        __darwin_ymm_reg __fpu_zmmh2;
        
        __darwin_ymm_reg __fpu_zmmh3;
        
        __darwin_ymm_reg __fpu_zmmh4;
        
        __darwin_ymm_reg __fpu_zmmh5;
        
        __darwin_ymm_reg __fpu_zmmh6;
        
        __darwin_ymm_reg __fpu_zmmh7;
        
        __darwin_ymm_reg __fpu_zmmh8;
        
        __darwin_ymm_reg __fpu_zmmh9;
        
        __darwin_ymm_reg __fpu_zmmh10;
        
        __darwin_ymm_reg __fpu_zmmh11;
        
        __darwin_ymm_reg __fpu_zmmh12;
        
        __darwin_ymm_reg __fpu_zmmh13;
        
        __darwin_ymm_reg __fpu_zmmh14;
        
        __darwin_ymm_reg __fpu_zmmh15;
        
        __darwin_zmm_reg __fpu_zmm16;
        
        __darwin_zmm_reg __fpu_zmm17;
        
        __darwin_zmm_reg __fpu_zmm18;
        
        __darwin_zmm_reg __fpu_zmm19;
        
        __darwin_zmm_reg __fpu_zmm20;
        
        __darwin_zmm_reg __fpu_zmm21;
        
        __darwin_zmm_reg __fpu_zmm22;
        
        __darwin_zmm_reg __fpu_zmm23;
        
        __darwin_zmm_reg __fpu_zmm24;
        
        __darwin_zmm_reg __fpu_zmm25;
        
        __darwin_zmm_reg __fpu_zmm26;
        
        __darwin_zmm_reg __fpu_zmm27;
        
        __darwin_zmm_reg __fpu_zmm28;
        
        __darwin_zmm_reg __fpu_zmm29;
        
        __darwin_zmm_reg __fpu_zmm30;
        
        __darwin_zmm_reg __fpu_zmm31;
    }
    
    uint32_t arc4random_uniform(uint32_t) @nogc nothrow;
    
    struct __darwin_x86_exception_state64
    {
        
        __uint16_t __trapno;
        
        __uint16_t __cpu;
        
        __uint32_t __err;
        
        __uint64_t __faultvaddr;
    }
    
    void arc4random_stir() @nogc nothrow;
    
    struct __darwin_x86_debug_state64
    {
        
        __uint64_t __dr0;
        
        __uint64_t __dr1;
        
        __uint64_t __dr2;
        
        __uint64_t __dr3;
        
        __uint64_t __dr4;
        
        __uint64_t __dr5;
        
        __uint64_t __dr6;
        
        __uint64_t __dr7;
    }
    
    struct __darwin_x86_cpmu_state64
    {
        
        __uint64_t[16] __ctrs;
    }
    
    void arc4random_buf(void*, size_t) @nogc nothrow;
    
    void arc4random_addrandom(ubyte*, int) @nogc nothrow;
    
    uint32_t arc4random() @nogc nothrow;
    
    void* malloc(c_ulong) @nogc nothrow;
    
    void* calloc(c_ulong, c_ulong) @nogc nothrow;
    
    void free(void*) @nogc nothrow;
    
    void* realloc(void*, c_ulong) @nogc nothrow;
    
    void* valloc(size_t) @nogc nothrow;
    
    void* aligned_alloc(c_ulong, c_ulong) @nogc nothrow;
    
    int posix_memalign(void**, size_t, size_t) @nogc nothrow;
    
    int unsetenv(const(char)*) @nogc nothrow;
    
    int unlockpt(int) @nogc nothrow;
    
    void srandom(uint) @nogc nothrow;
    
    void srand48(c_long) @nogc nothrow;
    
    char* setstate(const(char)*) @nogc nothrow;
    
    void setkey(const(char)*) @nogc nothrow;
    
    int setenv(const(char)*, const(char)*, int) @nogc nothrow;
    
    ushort* seed48(ushort*) @nogc nothrow;
    
    char* realpath(const(char)*, char*) @nogc nothrow;
    
    int rand_r(uint*) @nogc nothrow;
    
    c_long random() @nogc nothrow;
    
    int putenv(char*) @nogc nothrow;
    
    int ptsname_r(int, char*, size_t) @nogc nothrow;
    
    char* ptsname(int) @nogc nothrow;
    
    int posix_openpt(int) @nogc nothrow;
    
    int pthread_atfork(void function(), void function(), void function()) @nogc nothrow;
    
    int pthread_attr_destroy(pthread_attr_t*) @nogc nothrow;
    
    int pthread_attr_getdetachstate(const(pthread_attr_t)*, int*) @nogc nothrow;
    
    int pthread_attr_getguardsize(const(pthread_attr_t)*, size_t*) @nogc nothrow;
    
    int pthread_attr_getinheritsched(const(pthread_attr_t)*, int*) @nogc nothrow;
    
    int pthread_attr_getschedparam(const(pthread_attr_t)*, sched_param*) @nogc nothrow;
    
    int pthread_attr_getschedpolicy(const(pthread_attr_t)*, int*) @nogc nothrow;
    
    int pthread_attr_getscope(const(pthread_attr_t)*, int*) @nogc nothrow;
    
    int pthread_attr_getstack(const(pthread_attr_t)*, void**, size_t*) @nogc nothrow;
    
    int pthread_attr_getstackaddr(const(pthread_attr_t)*, void**) @nogc nothrow;
    
    int pthread_attr_getstacksize(const(pthread_attr_t)*, size_t*) @nogc nothrow;
    
    int pthread_attr_init(pthread_attr_t*) @nogc nothrow;
    
    int pthread_attr_setdetachstate(pthread_attr_t*, int) @nogc nothrow;
    
    int pthread_attr_setguardsize(pthread_attr_t*, size_t) @nogc nothrow;
    
    int pthread_attr_setinheritsched(pthread_attr_t*, int) @nogc nothrow;
    
    int pthread_attr_setschedparam(pthread_attr_t*, const(sched_param)*) @nogc nothrow;
    
    int pthread_attr_setschedpolicy(pthread_attr_t*, int) @nogc nothrow;
    
    int pthread_attr_setscope(pthread_attr_t*, int) @nogc nothrow;
    
    int pthread_attr_setstack(pthread_attr_t*, void*, size_t) @nogc nothrow;
    
    int pthread_attr_setstackaddr(pthread_attr_t*, void*) @nogc nothrow;
    
    int pthread_attr_setstacksize(pthread_attr_t*, size_t) @nogc nothrow;
    
    int pthread_cancel(pthread_t) @nogc nothrow;
    
    int pthread_cond_broadcast(pthread_cond_t*) @nogc nothrow;
    
    int pthread_cond_destroy(pthread_cond_t*) @nogc nothrow;
    
    int pthread_cond_init(pthread_cond_t*, const(pthread_condattr_t)*) @nogc nothrow;
    
    int pthread_cond_signal(pthread_cond_t*) @nogc nothrow;
    
    int pthread_cond_timedwait(pthread_cond_t*, pthread_mutex_t*, const(timespec)*) @nogc nothrow;
    
    int pthread_cond_wait(pthread_cond_t*, pthread_mutex_t*) @nogc nothrow;
    
    int pthread_condattr_destroy(pthread_condattr_t*) @nogc nothrow;
    
    int pthread_condattr_init(pthread_condattr_t*) @nogc nothrow;
    
    int pthread_condattr_getpshared(const(pthread_condattr_t)*, int*) @nogc nothrow;
    
    int pthread_condattr_setpshared(pthread_condattr_t*, int) @nogc nothrow;
    
    int pthread_create(pthread_t*, const(pthread_attr_t)*, void* function(void*), void*) @nogc nothrow;
    
    int pthread_detach(pthread_t) @nogc nothrow;
    
    int pthread_equal(pthread_t, pthread_t) @nogc nothrow;
    
    void pthread_exit(void*) @nogc nothrow;
    
    int pthread_getconcurrency() @nogc nothrow;
    
    int pthread_getschedparam(pthread_t, int*, sched_param*) @nogc nothrow;
    
    void* pthread_getspecific(pthread_key_t) @nogc nothrow;
    
    int pthread_join(pthread_t, void**) @nogc nothrow;
    
    int pthread_key_create(pthread_key_t*, void function(void*)) @nogc nothrow;
    
    int pthread_key_delete(pthread_key_t) @nogc nothrow;
    
    int pthread_mutex_destroy(pthread_mutex_t*) @nogc nothrow;
    
    int pthread_mutex_getprioceiling(const(pthread_mutex_t)*, int*) @nogc nothrow;
    
    int pthread_mutex_init(pthread_mutex_t*, const(pthread_mutexattr_t)*) @nogc nothrow;
    
    int pthread_mutex_lock(pthread_mutex_t*) @nogc nothrow;
    
    int pthread_mutex_setprioceiling(pthread_mutex_t*, int, int*) @nogc nothrow;
    
    int pthread_mutex_trylock(pthread_mutex_t*) @nogc nothrow;
    
    int pthread_mutex_unlock(pthread_mutex_t*) @nogc nothrow;
    
    int pthread_mutexattr_destroy(pthread_mutexattr_t*) @nogc nothrow;
    
    int pthread_mutexattr_getprioceiling(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    
    int pthread_mutexattr_getprotocol(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    
    int pthread_mutexattr_getpshared(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    
    int pthread_mutexattr_gettype(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    
    int pthread_mutexattr_getpolicy_np(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    
    int pthread_mutexattr_init(pthread_mutexattr_t*) @nogc nothrow;
    
    int pthread_mutexattr_setprioceiling(pthread_mutexattr_t*, int) @nogc nothrow;
    
    int pthread_mutexattr_setprotocol(pthread_mutexattr_t*, int) @nogc nothrow;
    
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int) @nogc nothrow;
    
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @nogc nothrow;
    
    int pthread_mutexattr_setpolicy_np(pthread_mutexattr_t*, int) @nogc nothrow;
    
    int pthread_once(pthread_once_t*, void function()) @nogc nothrow;
    
    int pthread_rwlock_destroy(pthread_rwlock_t*) @nogc nothrow;
    
    int pthread_rwlock_init(pthread_rwlock_t*, const(pthread_rwlockattr_t)*) @nogc nothrow;
    
    int pthread_rwlock_rdlock(pthread_rwlock_t*) @nogc nothrow;
    
    int pthread_rwlock_tryrdlock(pthread_rwlock_t*) @nogc nothrow;
    
    int pthread_rwlock_trywrlock(pthread_rwlock_t*) @nogc nothrow;
    
    int pthread_rwlock_wrlock(pthread_rwlock_t*) @nogc nothrow;
    
    int pthread_rwlock_unlock(pthread_rwlock_t*) @nogc nothrow;
    
    int pthread_rwlockattr_destroy(pthread_rwlockattr_t*) @nogc nothrow;
    
    int pthread_rwlockattr_getpshared(const(pthread_rwlockattr_t)*, int*) @nogc nothrow;
    
    int pthread_rwlockattr_init(pthread_rwlockattr_t*) @nogc nothrow;
    
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int) @nogc nothrow;
    
    pthread_t pthread_self() @nogc nothrow;
    
    int pthread_setcancelstate(int, int*) @nogc nothrow;
    
    int pthread_setcanceltype(int, int*) @nogc nothrow;
    
    int pthread_setconcurrency(int) @nogc nothrow;
    
    int pthread_setschedparam(pthread_t, int, const(sched_param)*) @nogc nothrow;
    
    int pthread_setspecific(pthread_key_t, const(void)*) @nogc nothrow;
    
    void pthread_testcancel() @nogc nothrow;
    
    int pthread_is_threaded_np() @nogc nothrow;
    
    int pthread_threadid_np(pthread_t, __uint64_t*) @nogc nothrow;
    
    int pthread_getname_np(pthread_t, char*, size_t) @nogc nothrow;
    
    int pthread_setname_np(const(char)*) @nogc nothrow;
    
    int pthread_main_np() @nogc nothrow;
    
    mach_port_t pthread_mach_thread_np(pthread_t) @nogc nothrow;
    
    size_t pthread_get_stacksize_np(pthread_t) @nogc nothrow;
    
    void* pthread_get_stackaddr_np(pthread_t) @nogc nothrow;
    
    int pthread_cond_signal_thread_np(pthread_cond_t*, pthread_t) @nogc nothrow;
    
    int pthread_cond_timedwait_relative_np(pthread_cond_t*, pthread_mutex_t*, const(timespec)*) @nogc nothrow;
    
    int pthread_create_suspended_np(pthread_t*, const(pthread_attr_t)*, void* function(void*), void*) @nogc nothrow;
    
    int pthread_kill(pthread_t, int) @nogc nothrow;
    
    pthread_t pthread_from_mach_thread_np(mach_port_t) @nogc nothrow;
    
    int pthread_sigmask(int, const(sigset_t)*, sigset_t*) @nogc nothrow;
    
    void pthread_yield_np() @nogc nothrow;
    
    void pthread_jit_write_protect_np(int) @nogc nothrow;
    
    int pthread_jit_write_protect_supported_np() @nogc nothrow;
    alias pthread_jit_write_callback_t = int function(void*);
    
    int pthread_jit_write_with_callback_np(pthread_jit_write_callback_t, void*) @nogc nothrow;
    
    void pthread_jit_write_freeze_callbacks_np() @nogc nothrow;
    
    int pthread_cpu_number_np(size_t*) @nogc nothrow;
    
    c_long nrand48(ushort*) @nogc nothrow;
    
    c_long mrand48() @nogc nothrow;
    
    int mkstemp(char*) @nogc nothrow;
    
    char* mktemp(char*) @nogc nothrow;
    
    c_long lrand48() @nogc nothrow;
    
    void lcong48(ushort*) @nogc nothrow;
    
    char* l64a(c_long) @nogc nothrow;
    
    c_long jrand48(ushort*) @nogc nothrow;
    
    char* initstate(uint, char*, size_t) @nogc nothrow;
    
    int pthread_attr_set_qos_class_np(pthread_attr_t*, qos_class_t, int) @nogc nothrow;
    
    int pthread_attr_get_qos_class_np(pthread_attr_t*, qos_class_t*, int*) @nogc nothrow;
    
    int pthread_set_qos_class_self_np(qos_class_t, int) @nogc nothrow;
    
    int pthread_get_qos_class_np(pthread_t, qos_class_t*, int*) @nogc nothrow;
    
    alias pthread_override_t = pthread_override_s*;
    struct pthread_override_s;
    
    pthread_override_t pthread_override_qos_class_start_np(pthread_t, qos_class_t, int) @nogc nothrow;
    
    int pthread_override_qos_class_end_np(pthread_override_t) @nogc nothrow;
    
    struct sched_param
    {
        
        int sched_priority;
        
        char[4] __opaque;
    }
    
    int sched_yield() @nogc nothrow;
    
    int sched_get_priority_min(int) @nogc nothrow;
    
    int sched_get_priority_max(int) @nogc nothrow;
    
    int grantpt(int) @nogc nothrow;
    
    int getsubopt(char**, char**, char**) @nogc nothrow;
    
    alias int_least8_t = int8_t;
    
    alias int_least16_t = int16_t;
    
    alias int_least32_t = int32_t;
    
    alias int_least64_t = int64_t;
    
    alias uint_least8_t = uint8_t;
    
    alias uint_least16_t = uint16_t;
    
    alias uint_least32_t = uint32_t;
    
    alias uint_least64_t = uint64_t;
    
    alias int_fast8_t = int8_t;
    
    alias int_fast16_t = int16_t;
    
    alias int_fast32_t = int32_t;
    
    alias int_fast64_t = int64_t;
    
    alias uint_fast8_t = uint8_t;
    
    alias uint_fast16_t = uint16_t;
    
    alias uint_fast32_t = uint32_t;
    
    alias uint_fast64_t = uint64_t;
    
    char* gcvt(double, int, char*) @nogc nothrow;
    
    char* fcvt(double, int, int*, int*) @nogc nothrow;
    
    double erand48(ushort*) @nogc nothrow;
    
    char* ecvt(double, int, int*, int*) @nogc nothrow;
    
    double drand48() @nogc nothrow;
    
    c_long a64l(const(char)*) @nogc nothrow;
    
    void _Exit(int) @nogc nothrow;
    
    int wctomb(char*, wchar_t) @nogc nothrow;
    
    size_t wcstombs(char*, const(wchar_t)*, size_t) @nogc nothrow;
    
    int system(const(char)*) @nogc nothrow;
    
    ulong strtoull(const(char)*, char**, int) @nogc nothrow;
    
    c_ulong strtoul(const(char)*, char**, int) @nogc nothrow;
    
    long strtoll(const(char)*, char**, int) @nogc nothrow;
    
    real strtold(const(char)*, char**) @nogc nothrow;
    
    c_long strtol(const(char)*, char**, int) @nogc nothrow;
    
    float strtof(const(char)*, char**) @nogc nothrow;
    
    double strtod(const(char)*, char**) @nogc nothrow;
    
    void srand(uint) @nogc nothrow;
    
    int rand() @nogc nothrow;
    
    void qsort(void*, size_t, size_t, int function(const(void)*, const(void)*)) @nogc nothrow;
    
    int mbtowc(wchar_t*, const(char)*, size_t) @nogc nothrow;
    
    size_t mbstowcs(wchar_t*, const(char)*, size_t) @nogc nothrow;
    
    int mblen(const(char)*, size_t) @nogc nothrow;
    
    lldiv_t lldiv(long, long) @nogc nothrow;
    
    long llabs(long) @nogc nothrow;
    
    ldiv_t ldiv(c_long, c_long) @nogc nothrow;
    
    c_long labs(c_long) @nogc nothrow;
    
    char* getenv(const(char)*) @nogc nothrow;
    
    void exit(int) @nogc nothrow;
    
    div_t div(int, int) @nogc nothrow;
    
    void* bsearch(const(void)*, const(void)*, size_t, size_t, int function(const(void)*, const(void)*)) @nogc nothrow;
    
    long atoll(const(char)*) @nogc nothrow;
    
    c_long atol(const(char)*) @nogc nothrow;
    
    int atoi(const(char)*) @nogc nothrow;
    
    struct div_t
    {
        
        int quot;
        
        int rem;
    }
    
    struct ldiv_t
    {
        
        c_long quot;
        
        c_long rem;
    }
    
    struct lldiv_t
    {
        
        long quot;
        
        long rem;
    }
    
    double atof(const(char)*) @nogc nothrow;
    
    int atexit(void function()) @nogc nothrow;
    
    extern export __gshared int __mb_cur_max;
    
    int abs(int) @nogc nothrow;
    
    void abort() @nogc nothrow;
}


