module interop.headers;
import core.stdc.config;
import core.stdc.stdarg: va_list;
static import core.simd;
static import std.conv;

struct Int128 { long lower; long upper; }
struct UInt128 { ulong lower; ulong upper; }

struct __locale_data { int dummy; }



alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }

    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }


    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(` `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
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
    alias wchar_t = int;
    alias size_t = c_ulong;
    alias ptrdiff_t = c_long;
    struct max_align_t
    {
        long __clang_max_align_nonce1;
        real __clang_max_align_nonce2;
    }
    int getdate_r(const(char)*, tm*) @nogc nothrow;
    tm* getdate(const(char)*) @nogc nothrow;
    extern __gshared int getdate_err;
    int timespec_get(timespec*, int) @nogc nothrow;
    int timer_getoverrun(void*) @nogc nothrow;
    int timer_gettime(void*, itimerspec*) @nogc nothrow;
    int timer_settime(void*, int, const(itimerspec)*, itimerspec*) @nogc nothrow;
    int timer_delete(void*) @nogc nothrow;
    int timer_create(int, sigevent*, void**) @nogc nothrow;
    int clock_getcpuclockid(int, int*) @nogc nothrow;
    int clock_nanosleep(int, int, const(timespec)*, timespec*) @nogc nothrow;
    int clock_settime(int, const(timespec)*) @nogc nothrow;
    int clock_gettime(int, timespec*) @nogc nothrow;
    int clock_getres(int, timespec*) @nogc nothrow;
    int nanosleep(const(timespec)*, timespec*) @nogc nothrow;
    int dysize(int) @nogc nothrow;
    c_long timelocal(tm*) @nogc nothrow;
    c_long timegm(tm*) @nogc nothrow;
    extern __gshared c_long timezone;
    extern __gshared int daylight;
    void tzset() @nogc nothrow;
    extern __gshared char*[2] tzname;
    extern __gshared c_long __timezone;
    extern __gshared int __daylight;
    extern __gshared char*[2] __tzname;
    char* ctime_r(const(c_long)*, char*) @nogc nothrow;
    char* asctime_r(const(tm)*, char*) @nogc nothrow;
    char* ctime(const(c_long)*) @nogc nothrow;
    char* asctime(const(tm)*) @nogc nothrow;
    tm* localtime_r(const(c_long)*, tm*) @nogc nothrow;
    tm* gmtime_r(const(c_long)*, tm*) @nogc nothrow;
    tm* localtime(const(c_long)*) @nogc nothrow;
    tm* gmtime(const(c_long)*) @nogc nothrow;
    char* strptime_l(const(char)*, const(char)*, tm*, __locale_struct*) @nogc nothrow;
    c_ulong strftime_l(char*, c_ulong, const(char)*, const(tm)*, __locale_struct*) @nogc nothrow;
    char* strptime(const(char)*, const(char)*, tm*) @nogc nothrow;
    c_ulong strftime(char*, c_ulong, const(char)*, const(tm)*) @nogc nothrow;
    c_long mktime(tm*) @nogc nothrow;
    double difftime(c_long, c_long) @nogc nothrow;
    c_long time(c_long*) @nogc nothrow;
    c_long clock() @nogc nothrow;
    struct sigevent;
    alias fsfilcnt64_t = c_ulong;
    alias fsblkcnt64_t = c_ulong;
    alias blkcnt64_t = c_long;
    alias fsfilcnt_t = c_ulong;
    alias fsblkcnt_t = c_ulong;
    alias blkcnt_t = c_long;
    alias blksize_t = c_long;
    alias register_t = c_long;
    alias u_int64_t = c_ulong;
    alias u_int32_t = uint;
    alias u_int16_t = ushort;
    alias u_int8_t = ubyte;
    alias suseconds_t = c_long;
    alias useconds_t = uint;
    alias key_t = int;
    alias caddr_t = char*;
    alias daddr_t = int;
    alias ssize_t = c_long;
    alias id_t = uint;
    alias off64_t = c_long;
    alias off_t = c_long;
    alias uid_t = uint;
    alias nlink_t = c_ulong;
    alias mode_t = uint;
    alias gid_t = uint;
    alias dev_t = c_ulong;
    alias ino64_t = c_ulong;
    alias ino_t = c_ulong;
    alias loff_t = c_long;
    alias fsid_t = __fsid_t;
    alias u_quad_t = c_ulong;
    alias quad_t = c_long;
    alias u_long = c_ulong;
    alias u_int = uint;
    alias u_short = ushort;
    alias u_char = ubyte;
    int pselect(int, fd_set*, fd_set*, fd_set*, const(timespec)*, const(__sigset_t)*) @nogc nothrow;
    int select(int, fd_set*, fd_set*, fd_set*, timeval*) @nogc nothrow;
    alias fd_mask = c_long;
    struct fd_set
    {
        c_long[16] fds_bits;
    }
    alias __fd_mask = c_long;
    pragma(mangle, "alloca") void* alloca_(c_ulong) @nogc nothrow;
    static ushort __bswap_16(ushort) @nogc nothrow;
    static uint __bswap_32(uint) @nogc nothrow;
    static c_ulong __bswap_64(c_ulong) @nogc nothrow;
    int getloadavg(double*, int) @nogc nothrow;
    alias __cpu_mask = c_ulong;
    int getpt() @nogc nothrow;
    struct cpu_set_t
    {
        c_ulong[16] __bits;
    }
    int ptsname_r(int, char*, c_ulong) @nogc nothrow;
    char* ptsname(int) @nogc nothrow;
    int unlockpt(int) @nogc nothrow;
    int grantpt(int) @nogc nothrow;
    int __sched_cpucount(c_ulong, const(cpu_set_t)*) @nogc nothrow;
    cpu_set_t* __sched_cpualloc(c_ulong) @nogc nothrow;
    void __sched_cpufree(cpu_set_t*) @nogc nothrow;
    int posix_openpt(int) @nogc nothrow;
    int getsubopt(char**, char**, char**) @nogc nothrow;
    int rpmatch(const(char)*) @nogc nothrow;
    c_ulong wcstombs(char*, const(int)*, c_ulong) @nogc nothrow;
    c_ulong mbstowcs(int*, const(char)*, c_ulong) @nogc nothrow;
    int wctomb(char*, int) @nogc nothrow;
    int mbtowc(int*, const(char)*, c_ulong) @nogc nothrow;
    int mblen(const(char)*, c_ulong) @nogc nothrow;
    int qfcvt_r(real, int, int*, int*, char*, c_ulong) @nogc nothrow;
    alias _Float32 = float;
    int qecvt_r(real, int, int*, int*, char*, c_ulong) @nogc nothrow;
    int fcvt_r(double, int, int*, int*, char*, c_ulong) @nogc nothrow;
    alias _Float64 = double;
    int ecvt_r(double, int, int*, int*, char*, c_ulong) @nogc nothrow;
    alias _Float32x = double;
    char* qgcvt(real, int, char*) @nogc nothrow;
    alias _Float64x = real;
    char* qfcvt(real, int, int*, int*) @nogc nothrow;
    char* qecvt(real, int, int*, int*) @nogc nothrow;
    char* gcvt(double, int, char*) @nogc nothrow;
    char* fcvt(double, int, int*, int*) @nogc nothrow;
    char* ecvt(double, int, int*, int*) @nogc nothrow;
    lldiv_t lldiv(long, long) @nogc nothrow;
    ldiv_t ldiv(c_long, c_long) @nogc nothrow;
    div_t div(int, int) @nogc nothrow;
    long llabs(long) @nogc nothrow;
    alias pthread_t = c_ulong;
    union pthread_mutexattr_t
    {
        char[4] __size;
        int __align;
    }
    union pthread_condattr_t
    {
        char[4] __size;
        int __align;
    }
    alias pthread_key_t = uint;
    alias pthread_once_t = int;
    union pthread_attr_t
    {
        char[56] __size;
        c_long __align;
    }
    union pthread_mutex_t
    {
        __pthread_mutex_s __data;
        char[40] __size;
        c_long __align;
    }
    union pthread_cond_t
    {
        __pthread_cond_s __data;
        char[48] __size;
        long __align;
    }
    union pthread_rwlock_t
    {
        __pthread_rwlock_arch_t __data;
        char[56] __size;
        c_long __align;
    }
    union pthread_rwlockattr_t
    {
        char[8] __size;
        c_long __align;
    }
    alias pthread_spinlock_t = int;
    union pthread_barrier_t
    {
        char[32] __size;
        c_long __align;
    }
    union pthread_barrierattr_t
    {
        char[4] __size;
        int __align;
    }
    c_long labs(c_long) @nogc nothrow;
    int abs(int) @nogc nothrow;
    void qsort_r(void*, c_ulong, c_ulong, int function(const(void)*, const(void)*, void*), void*) @nogc nothrow;
    void qsort(void*, c_ulong, c_ulong, int function(const(void)*, const(void)*)) @nogc nothrow;
    void* bsearch(const(void)*, const(void)*, c_ulong, c_ulong, int function(const(void)*, const(void)*)) @nogc nothrow;
    alias __compar_d_fn_t = int function(const(void)*, const(void)*, void*);
    alias comparison_fn_t = int function(const(void)*, const(void)*);
    alias __compar_fn_t = int function(const(void)*, const(void)*);
    char* realpath(const(char)*, char*) @nogc nothrow;
    char* canonicalize_file_name(const(char)*) @nogc nothrow;
    int system(const(char)*) @nogc nothrow;
    int mkostemps64(char*, int, int) @nogc nothrow;
    int clone(int function(void*), void*, int, void*, ...) @nogc nothrow;
    int unshare(int) @nogc nothrow;
    int sched_getcpu() @nogc nothrow;
    int getcpu(uint*, uint*) @nogc nothrow;
    int setns(int, int) @nogc nothrow;
    int mkostemps(char*, int, int) @nogc nothrow;
    alias __jmp_buf = c_long[8];
    int mkostemp64(char*, int) @nogc nothrow;
    alias int8_t = byte;
    alias int16_t = short;
    alias int32_t = int;
    alias int64_t = c_long;
    alias uint8_t = ubyte;
    alias uint16_t = ushort;
    alias uint32_t = uint;
    alias uint64_t = ulong;
    struct __pthread_mutex_s
    {
        int __lock;
        uint __count;
        int __owner;
        uint __nusers;
        int __kind;
        short __spins;
        short __elision;
        __pthread_internal_list __list;
    }
    int mkostemp(char*, int) @nogc nothrow;
    struct __pthread_rwlock_arch_t
    {
        uint __readers;
        uint __writers;
        uint __wrphase_futex;
        uint __writers_futex;
        uint __pad3;
        uint __pad4;
        int __cur_writer;
        int __shared;
        byte __rwelision;
        ubyte[7] __pad1;
        c_ulong __pad2;
        uint __flags;
    }
    alias __pthread_list_t = __pthread_internal_list;
    struct __pthread_internal_list
    {
        __pthread_internal_list* __prev;
        __pthread_internal_list* __next;
    }
    alias __pthread_slist_t = __pthread_internal_slist;
    struct __pthread_internal_slist
    {
        __pthread_internal_slist* __next;
    }
    struct __pthread_cond_s
    {
        static union _Anonymous_0
        {
            ulong __wseq;
            static struct _Anonymous_1
            {
                uint __low;
                uint __high;
            }
            _Anonymous_1 __wseq32;
        }
        _Anonymous_0 _anonymous_2;
        auto __wseq() @property @nogc pure nothrow { return _anonymous_2.__wseq; }
        void __wseq(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_2.__wseq = val; }
        auto __wseq32() @property @nogc pure nothrow { return _anonymous_2.__wseq32; }
        void __wseq32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_2.__wseq32 = val; }
        static union _Anonymous_3
        {
            ulong __g1_start;
            static struct _Anonymous_4
            {
                uint __low;
                uint __high;
            }
            _Anonymous_4 __g1_start32;
        }
        _Anonymous_3 _anonymous_5;
        auto __g1_start() @property @nogc pure nothrow { return _anonymous_5.__g1_start; }
        void __g1_start(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_5.__g1_start = val; }
        auto __g1_start32() @property @nogc pure nothrow { return _anonymous_5.__g1_start32; }
        void __g1_start32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_5.__g1_start32 = val; }
        uint[2] __g_refs;
        uint[2] __g_size;
        uint __g1_orig_size;
        uint __wrefs;
        uint[2] __g_signals;
    }
    char* mkdtemp(char*) @nogc nothrow;
    int mkstemps64(char*, int) @nogc nothrow;
    int mkstemps(char*, int) @nogc nothrow;
    int mkstemp64(char*) @nogc nothrow;
    int clock_adjtime(int, timex*) @nogc nothrow;
    int mkstemp(char*) @nogc nothrow;
    struct timex
    {
        import std.bitmanip: bitfields;

        align(4):
        uint modes;
        c_long offset;
        c_long freq;
        c_long maxerror;
        c_long esterror;
        int status;
        c_long constant;
        c_long precision;
        c_long tolerance;
        timeval time;
        c_long tick;
        c_long ppsfreq;
        c_long jitter;
        int shift;
        c_long stabil;
        c_long jitcnt;
        c_long calcnt;
        c_long errcnt;
        c_long stbcnt;
        int tai;
        mixin(bitfields!(
            int, "_anonymous_6", 32,
            int, "_anonymous_7", 32,
        ));
        mixin(bitfields!(
            int, "_anonymous_8", 32,
            int, "_anonymous_9", 32,
        ));
        mixin(bitfields!(
            int, "_anonymous_10", 32,
            int, "_anonymous_11", 32,
        ));
        mixin(bitfields!(
            int, "_anonymous_12", 32,
            int, "_anonymous_13", 32,
        ));
        mixin(bitfields!(
            int, "_anonymous_14", 32,
            int, "_anonymous_15", 32,
        ));
        mixin(bitfields!(
            int, "_anonymous_16", 32,
        ));
    }
    char* mktemp(char*) @nogc nothrow;
    int clearenv() @nogc nothrow;
    int unsetenv(const(char)*) @nogc nothrow;
    int setenv(const(char)*, const(char)*, int) @nogc nothrow;
    int putenv(char*) @nogc nothrow;
    char* secure_getenv(const(char)*) @nogc nothrow;
    char* getenv(const(char)*) @nogc nothrow;
    void _Exit(int) @nogc nothrow;
    void quick_exit(int) @nogc nothrow;
    void exit(int) @nogc nothrow;
    int on_exit(void function(int, void*), void*) @nogc nothrow;
    alias __u_char = ubyte;
    alias __u_short = ushort;
    alias __u_int = uint;
    alias __u_long = c_ulong;
    alias __int8_t = byte;
    alias __uint8_t = ubyte;
    alias __int16_t = short;
    alias __uint16_t = ushort;
    alias __int32_t = int;
    alias __uint32_t = uint;
    alias __int64_t = c_long;
    alias __uint64_t = c_ulong;
    alias __int_least8_t = byte;
    alias __uint_least8_t = ubyte;
    alias __int_least16_t = short;
    alias __uint_least16_t = ushort;
    alias __int_least32_t = int;
    alias __uint_least32_t = uint;
    alias __int_least64_t = c_long;
    alias __uint_least64_t = c_ulong;
    alias __quad_t = c_long;
    alias __u_quad_t = c_ulong;
    alias __intmax_t = c_long;
    alias __uintmax_t = c_ulong;
    int at_quick_exit(void function()) @nogc nothrow;
    int atexit(void function()) @nogc nothrow;
    void abort() @nogc nothrow;
    void* aligned_alloc(c_ulong, c_ulong) @nogc nothrow;
    alias __dev_t = c_ulong;
    alias __uid_t = uint;
    alias __gid_t = uint;
    alias __ino_t = c_ulong;
    alias __ino64_t = c_ulong;
    alias __mode_t = uint;
    alias __nlink_t = c_ulong;
    alias __off_t = c_long;
    alias __off64_t = c_long;
    alias __pid_t = int;
    struct __fsid_t
    {
        int[2] __val;
    }
    alias __clock_t = c_long;
    alias __rlim_t = c_ulong;
    alias __rlim64_t = c_ulong;
    alias __id_t = uint;
    alias __time_t = c_long;
    alias __useconds_t = uint;
    alias __suseconds_t = c_long;
    alias __daddr_t = int;
    alias __key_t = int;
    alias __clockid_t = int;
    alias __timer_t = void*;
    alias __blksize_t = c_long;
    alias __blkcnt_t = c_long;
    alias __blkcnt64_t = c_long;
    alias __fsblkcnt_t = c_ulong;
    alias __fsblkcnt64_t = c_ulong;
    alias __fsfilcnt_t = c_ulong;
    alias __fsfilcnt64_t = c_ulong;
    alias __fsword_t = c_long;
    alias __ssize_t = c_long;
    alias __syscall_slong_t = c_long;
    alias __syscall_ulong_t = c_ulong;
    alias __loff_t = c_long;
    alias __caddr_t = char*;
    alias __intptr_t = c_long;
    alias __socklen_t = uint;
    alias __sig_atomic_t = int;
    struct __locale_struct
    {
        __locale_data*[13] __locales;
        const(ushort)* __ctype_b;
        const(int)* __ctype_tolower;
        const(int)* __ctype_toupper;
        const(char)*[13] __names;
    }
    alias __locale_t = __locale_struct*;
    struct __sigset_t
    {
        c_ulong[16] __val;
    }
    alias clock_t = c_long;
    int posix_memalign(void**, c_ulong, c_ulong) @nogc nothrow;
    alias clockid_t = int;
    alias locale_t = __locale_struct*;
    alias sigset_t = __sigset_t;
    struct itimerspec
    {
        timespec it_interval;
        timespec it_value;
    }
    struct sched_param
    {
        int sched_priority;
    }
    struct timespec
    {
        c_long tv_sec;
        c_long tv_nsec;
    }
    void* valloc(c_ulong) @nogc nothrow;
    struct timeval
    {
        c_long tv_sec;
        c_long tv_usec;
    }
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
        const(char)* tm_zone;
    }
    alias time_t = c_long;
    alias timer_t = void*;
    void free(void*) @nogc nothrow;
    void* reallocarray(void*, c_ulong, c_ulong) @nogc nothrow;
    void* realloc(void*, c_ulong) @nogc nothrow;
    void* calloc(c_ulong, c_ulong) @nogc nothrow;
    void* malloc(c_ulong) @nogc nothrow;
    int lcong48_r(ushort*, drand48_data*) @nogc nothrow;
    int seed48_r(ushort*, drand48_data*) @nogc nothrow;
    int srand48_r(c_long, drand48_data*) @nogc nothrow;
    int jrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;
    int mrand48_r(drand48_data*, c_long*) @nogc nothrow;
    int nrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;
    static ushort __uint16_identity(ushort) @nogc nothrow;
    static uint __uint32_identity(uint) @nogc nothrow;
    static c_ulong __uint64_identity(c_ulong) @nogc nothrow;
    int lrand48_r(drand48_data*, c_long*) @nogc nothrow;
    int erand48_r(ushort*, drand48_data*, double*) @nogc nothrow;
    int drand48_r(drand48_data*, double*) @nogc nothrow;
    struct drand48_data
    {
        ushort[3] __x;
        ushort[3] __old_x;
        ushort __c;
        ushort __init;
        ulong __a;
    }
    void lcong48(ushort*) @nogc nothrow;
    ushort* seed48(ushort*) @nogc nothrow;
    void srand48(c_long) @nogc nothrow;
    c_long jrand48(ushort*) @nogc nothrow;
    c_long mrand48() @nogc nothrow;
    c_long nrand48(ushort*) @nogc nothrow;
    c_long lrand48() @nogc nothrow;
    double erand48(ushort*) @nogc nothrow;
    double drand48() @nogc nothrow;
    int rand_r(uint*) @nogc nothrow;
    void srand(uint) @nogc nothrow;
    int rand() @nogc nothrow;
    int setstate_r(char*, random_data*) @nogc nothrow;
    int initstate_r(uint, char*, c_ulong, random_data*) @nogc nothrow;
    int srandom_r(uint, random_data*) @nogc nothrow;
    int random_r(random_data*, int*) @nogc nothrow;
    struct random_data
    {
        int* fptr;
        int* rptr;
        int* state;
        int rand_type;
        int rand_deg;
        int rand_sep;
        int* end_ptr;
    }
    char* setstate(char*) @nogc nothrow;
    char* initstate(uint, char*, c_ulong) @nogc nothrow;
    void srandom(uint) @nogc nothrow;
    c_long random() @nogc nothrow;
    c_long a64l(const(char)*) @nogc nothrow;
    char* l64a(c_long) @nogc nothrow;
    real strtof64x_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    double strtof32x_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    double strtof64_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    float strtof32_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    real strtold_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    float strtof_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    double strtod_l(const(char)*, char**, __locale_struct*) @nogc nothrow;
    ulong strtoull_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    long strtoll_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    c_ulong strtoul_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    c_long strtol_l(const(char)*, char**, int, __locale_struct*) @nogc nothrow;
    int strfromf64x(char*, c_ulong, const(char)*, real) @nogc nothrow;
    void grpc_metadata_array_init(grpc_metadata_array*) @nogc nothrow;
    void grpc_metadata_array_destroy(grpc_metadata_array*) @nogc nothrow;
    void grpc_call_details_init(grpc_call_details*) @nogc nothrow;
    void grpc_call_details_destroy(grpc_call_details*) @nogc nothrow;
    void grpc_register_plugin(void function(), void function()) @nogc nothrow;
    void grpc_init() @nogc nothrow;
    void grpc_shutdown() @nogc nothrow;
    int grpc_is_initialized() @nogc nothrow;
    void grpc_shutdown_blocking() @nogc nothrow;
    const(char)* grpc_version_string() @nogc nothrow;
    const(char)* grpc_g_stands_for() @nogc nothrow;
    const(grpc_completion_queue_factory)* grpc_completion_queue_factory_lookup(const(grpc_completion_queue_attributes)*) @nogc nothrow;
    grpc_completion_queue* grpc_completion_queue_create_for_next(void*) @nogc nothrow;
    grpc_completion_queue* grpc_completion_queue_create_for_pluck(void*) @nogc nothrow;
    grpc_completion_queue* grpc_completion_queue_create_for_callback(grpc_experimental_completion_queue_functor*, void*) @nogc nothrow;
    grpc_completion_queue* grpc_completion_queue_create(const(grpc_completion_queue_factory)*, const(grpc_completion_queue_attributes)*, void*) @nogc nothrow;
    grpc_event grpc_completion_queue_next(grpc_completion_queue*, gpr_timespec, void*) @nogc nothrow;
    grpc_event grpc_completion_queue_pluck(grpc_completion_queue*, void*, gpr_timespec, void*) @nogc nothrow;
    void grpc_completion_queue_shutdown(grpc_completion_queue*) @nogc nothrow;
    void grpc_completion_queue_destroy(grpc_completion_queue*) @nogc nothrow;
    void grpc_completion_queue_thread_local_cache_init(grpc_completion_queue*) @nogc nothrow;
    int grpc_completion_queue_thread_local_cache_flush(grpc_completion_queue*, void**, int*) @nogc nothrow;
    grpc_connectivity_state grpc_channel_check_connectivity_state(grpc_channel*, int) @nogc nothrow;
    int grpc_channel_num_external_connectivity_watchers(grpc_channel*) @nogc nothrow;
    void grpc_channel_watch_connectivity_state(grpc_channel*, grpc_connectivity_state, gpr_timespec, grpc_completion_queue*, void*) @nogc nothrow;
    int grpc_channel_support_connectivity_watcher(grpc_channel*) @nogc nothrow;
    grpc_call* grpc_channel_create_call(grpc_channel*, grpc_call*, uint, grpc_completion_queue*, grpc_slice, const(grpc_slice)*, gpr_timespec, void*) @nogc nothrow;
    void grpc_channel_ping(grpc_channel*, grpc_completion_queue*, void*, void*) @nogc nothrow;
    void* grpc_channel_register_call(grpc_channel*, const(char)*, const(char)*, void*) @nogc nothrow;
    grpc_call* grpc_channel_create_registered_call(grpc_channel*, grpc_call*, uint, grpc_completion_queue*, void*, gpr_timespec, void*) @nogc nothrow;
    void* grpc_call_arena_alloc(grpc_call*, c_ulong) @nogc nothrow;
    grpc_call_error grpc_call_start_batch(grpc_call*, const(grpc_op)*, c_ulong, void*, void*) @nogc nothrow;
    char* grpc_call_get_peer(grpc_call*) @nogc nothrow;
    struct census_context;
    void grpc_census_call_set_context(grpc_call*, census_context*) @nogc nothrow;
    census_context* grpc_census_call_get_context(grpc_call*) @nogc nothrow;
    char* grpc_channel_get_target(grpc_channel*) @nogc nothrow;
    void grpc_channel_get_info(grpc_channel*, const(grpc_channel_info)*) @nogc nothrow;
    void grpc_channel_reset_connect_backoff(grpc_channel*) @nogc nothrow;
    grpc_channel* grpc_insecure_channel_create(const(char)*, const(grpc_channel_args)*, void*) @nogc nothrow;
    grpc_channel* grpc_lame_client_channel_create(const(char)*, grpc_status_code, const(char)*) @nogc nothrow;
    void grpc_channel_destroy(grpc_channel*) @nogc nothrow;
    grpc_call_error grpc_call_cancel(grpc_call*, void*) @nogc nothrow;
    grpc_call_error grpc_call_cancel_with_status(grpc_call*, grpc_status_code, const(char)*, void*) @nogc nothrow;
    void grpc_call_ref(grpc_call*) @nogc nothrow;
    void grpc_call_unref(grpc_call*) @nogc nothrow;
    grpc_call_error grpc_server_request_call(grpc_server*, grpc_call**, grpc_call_details*, grpc_metadata_array*, grpc_completion_queue*, grpc_completion_queue*, void*) @nogc nothrow;
    alias grpc_server_register_method_payload_handling = _Anonymous_17;
    enum _Anonymous_17
    {
        GRPC_SRM_PAYLOAD_NONE = 0,
        GRPC_SRM_PAYLOAD_READ_INITIAL_BYTE_BUFFER = 1,
    }
    enum GRPC_SRM_PAYLOAD_NONE = _Anonymous_17.GRPC_SRM_PAYLOAD_NONE;
    enum GRPC_SRM_PAYLOAD_READ_INITIAL_BYTE_BUFFER = _Anonymous_17.GRPC_SRM_PAYLOAD_READ_INITIAL_BYTE_BUFFER;
    void* grpc_server_register_method(grpc_server*, const(char)*, const(char)*, grpc_server_register_method_payload_handling, uint) @nogc nothrow;
    grpc_call_error grpc_server_request_registered_call(grpc_server*, void*, grpc_call**, gpr_timespec*, grpc_metadata_array*, grpc_byte_buffer**, grpc_completion_queue*, grpc_completion_queue*, void*) @nogc nothrow;
    grpc_server* grpc_server_create(const(grpc_channel_args)*, void*) @nogc nothrow;
    void grpc_server_register_completion_queue(grpc_server*, grpc_completion_queue*, void*) @nogc nothrow;
    int grpc_server_add_insecure_http2_port(grpc_server*, const(char)*) @nogc nothrow;
    void grpc_server_start(grpc_server*) @nogc nothrow;
    void grpc_server_shutdown_and_notify(grpc_server*, grpc_completion_queue*, void*) @nogc nothrow;
    void grpc_server_cancel_all_calls(grpc_server*) @nogc nothrow;
    void grpc_server_destroy(grpc_server*) @nogc nothrow;
    int grpc_tracer_set_enabled(const(char)*, int) @nogc nothrow;
    int grpc_header_key_is_legal(grpc_slice) @nogc nothrow;
    int grpc_header_nonbin_value_is_legal(grpc_slice) @nogc nothrow;
    int grpc_is_binary_header(grpc_slice) @nogc nothrow;
    const(char)* grpc_call_error_to_string(grpc_call_error) @nogc nothrow;
    grpc_resource_quota* grpc_resource_quota_create(const(char)*) @nogc nothrow;
    void grpc_resource_quota_ref(grpc_resource_quota*) @nogc nothrow;
    void grpc_resource_quota_unref(grpc_resource_quota*) @nogc nothrow;
    void grpc_resource_quota_resize(grpc_resource_quota*, c_ulong) @nogc nothrow;
    void grpc_resource_quota_set_max_threads(grpc_resource_quota*, int) @nogc nothrow;
    const(grpc_arg_pointer_vtable)* grpc_resource_quota_arg_vtable() @nogc nothrow;
    char* grpc_channelz_get_top_channels(c_long) @nogc nothrow;
    char* grpc_channelz_get_servers(c_long) @nogc nothrow;
    char* grpc_channelz_get_server(c_long) @nogc nothrow;
    char* grpc_channelz_get_server_sockets(c_long, c_long, c_long) @nogc nothrow;
    char* grpc_channelz_get_channel(c_long) @nogc nothrow;
    char* grpc_channelz_get_subchannel(c_long) @nogc nothrow;
    char* grpc_channelz_get_socket(c_long) @nogc nothrow;
    struct grpc_auth_context;
    struct grpc_auth_property_iterator
    {
        const(grpc_auth_context)* ctx;
        c_ulong index;
        const(char)* name;
    }
    struct grpc_auth_property
    {
        char* name;
        char* value;
        c_ulong value_length;
    }
    const(grpc_auth_property)* grpc_auth_property_iterator_next(grpc_auth_property_iterator*) @nogc nothrow;
    grpc_auth_property_iterator grpc_auth_context_property_iterator(const(grpc_auth_context)*) @nogc nothrow;
    grpc_auth_property_iterator grpc_auth_context_peer_identity(const(grpc_auth_context)*) @nogc nothrow;
    grpc_auth_property_iterator grpc_auth_context_find_properties_by_name(const(grpc_auth_context)*, const(char)*) @nogc nothrow;
    const(char)* grpc_auth_context_peer_identity_property_name(const(grpc_auth_context)*) @nogc nothrow;
    int grpc_auth_context_peer_is_authenticated(const(grpc_auth_context)*) @nogc nothrow;
    grpc_auth_context* grpc_call_auth_context(grpc_call*) @nogc nothrow;
    void grpc_auth_context_release(grpc_auth_context*) @nogc nothrow;
    void grpc_auth_context_add_property(grpc_auth_context*, const(char)*, const(char)*, c_ulong) @nogc nothrow;
    void grpc_auth_context_add_cstring_property(grpc_auth_context*, const(char)*, const(char)*) @nogc nothrow;
    int grpc_auth_context_set_peer_identity_property_name(grpc_auth_context*, const(char)*) @nogc nothrow;
    struct grpc_ssl_session_cache;
    grpc_ssl_session_cache* grpc_ssl_session_cache_create_lru(c_ulong) @nogc nothrow;
    void grpc_ssl_session_cache_destroy(grpc_ssl_session_cache*) @nogc nothrow;
    grpc_arg grpc_ssl_session_cache_create_channel_arg(grpc_ssl_session_cache*) @nogc nothrow;
    struct grpc_channel_credentials;
    void grpc_channel_credentials_release(grpc_channel_credentials*) @nogc nothrow;
    grpc_channel_credentials* grpc_google_default_credentials_create() @nogc nothrow;
    alias grpc_ssl_roots_override_callback = grpc_ssl_roots_override_result function(char**);
    void grpc_set_ssl_roots_override_callback(grpc_ssl_roots_override_result function(char**)) @nogc nothrow;
    struct grpc_ssl_pem_key_cert_pair
    {
        const(char)* private_key;
        const(char)* cert_chain;
    }
    struct verify_peer_options
    {
        int function(const(char)*, const(char)*, void*) verify_peer_callback;
        void* verify_peer_callback_userdata;
        void function(void*) verify_peer_destruct;
    }
    struct grpc_ssl_verify_peer_options
    {
        int function(const(char)*, const(char)*, void*) verify_peer_callback;
        void* verify_peer_callback_userdata;
        void function(void*) verify_peer_destruct;
    }
    grpc_channel_credentials* grpc_ssl_credentials_create(const(char)*, grpc_ssl_pem_key_cert_pair*, const(verify_peer_options)*, void*) @nogc nothrow;
    grpc_channel_credentials* grpc_ssl_credentials_create_ex(const(char)*, grpc_ssl_pem_key_cert_pair*, const(grpc_ssl_verify_peer_options)*, void*) @nogc nothrow;
    struct grpc_call_credentials;
    void grpc_call_credentials_release(grpc_call_credentials*) @nogc nothrow;
    grpc_channel_credentials* grpc_composite_channel_credentials_create(grpc_channel_credentials*, grpc_call_credentials*, void*) @nogc nothrow;
    grpc_call_credentials* grpc_composite_call_credentials_create(grpc_call_credentials*, grpc_call_credentials*, void*) @nogc nothrow;
    grpc_call_credentials* grpc_google_compute_engine_credentials_create(void*) @nogc nothrow;
    gpr_timespec grpc_max_auth_token_lifetime() @nogc nothrow;
    grpc_call_credentials* grpc_service_account_jwt_access_credentials_create(const(char)*, gpr_timespec, void*) @nogc nothrow;
    grpc_call_credentials* grpc_google_refresh_token_credentials_create(const(char)*, void*) @nogc nothrow;
    grpc_call_credentials* grpc_access_token_credentials_create(const(char)*, void*) @nogc nothrow;
    grpc_call_credentials* grpc_google_iam_credentials_create(const(char)*, const(char)*, void*) @nogc nothrow;
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
    grpc_call_credentials* grpc_sts_credentials_create(const(grpc_sts_credentials_options)*, void*) @nogc nothrow;
    alias grpc_credentials_plugin_metadata_cb = void function(void*, const(grpc_metadata)*, c_ulong, grpc_status_code, const(char)*);
    struct grpc_auth_metadata_context
    {
        const(char)* service_url;
        const(char)* method_name;
        const(grpc_auth_context)* channel_auth_context;
        void* reserved;
    }
    int strfromf32x(char*, c_ulong, const(char)*, double) @nogc nothrow;
    struct grpc_metadata_credentials_plugin
    {
        int function(void*, grpc_auth_metadata_context, void function(void*, const(grpc_metadata)*, c_ulong, grpc_status_code, const(char)*), void*, grpc_metadata[4], c_ulong*, grpc_status_code*, const(char)**) get_metadata;
        void function(void*) destroy;
        void* state;
        const(char)* type;
    }
    grpc_call_credentials* grpc_metadata_credentials_create_from_plugin(grpc_metadata_credentials_plugin, grpc_security_level, void*) @nogc nothrow;
    grpc_channel* grpc_secure_channel_create(grpc_channel_credentials*, const(char)*, const(grpc_channel_args)*, void*) @nogc nothrow;
    struct grpc_server_credentials;
    void grpc_server_credentials_release(grpc_server_credentials*) @nogc nothrow;
    struct grpc_ssl_server_certificate_config;
    grpc_ssl_server_certificate_config* grpc_ssl_server_certificate_config_create(const(char)*, const(grpc_ssl_pem_key_cert_pair)*, c_ulong) @nogc nothrow;
    void grpc_ssl_server_certificate_config_destroy(grpc_ssl_server_certificate_config*) @nogc nothrow;
    alias grpc_ssl_server_certificate_config_callback = grpc_ssl_certificate_config_reload_status function(void*, grpc_ssl_server_certificate_config**);
    grpc_server_credentials* grpc_ssl_server_credentials_create(const(char)*, grpc_ssl_pem_key_cert_pair*, c_ulong, int, void*) @nogc nothrow;
    grpc_server_credentials* grpc_ssl_server_credentials_create_ex(const(char)*, grpc_ssl_pem_key_cert_pair*, c_ulong, grpc_ssl_client_certificate_request_type, void*) @nogc nothrow;
    struct grpc_ssl_server_credentials_options;
    grpc_ssl_server_credentials_options* grpc_ssl_server_credentials_create_options_using_config(grpc_ssl_client_certificate_request_type, grpc_ssl_server_certificate_config*) @nogc nothrow;
    grpc_ssl_server_credentials_options* grpc_ssl_server_credentials_create_options_using_config_fetcher(grpc_ssl_client_certificate_request_type, grpc_ssl_certificate_config_reload_status function(void*, grpc_ssl_server_certificate_config**), void*) @nogc nothrow;
    void grpc_ssl_server_credentials_options_destroy(grpc_ssl_server_credentials_options*) @nogc nothrow;
    grpc_server_credentials* grpc_ssl_server_credentials_create_with_options(grpc_ssl_server_credentials_options*) @nogc nothrow;
    int grpc_server_add_secure_http2_port(grpc_server*, const(char)*, grpc_server_credentials*) @nogc nothrow;
    grpc_call_error grpc_call_set_credentials(grpc_call*, grpc_call_credentials*) @nogc nothrow;
    alias grpc_process_auth_metadata_done_cb = void function(void*, const(grpc_metadata)*, c_ulong, const(grpc_metadata)*, c_ulong, grpc_status_code, const(char)*);
    struct grpc_auth_metadata_processor
    {
        void function(void*, grpc_auth_context*, const(grpc_metadata)*, c_ulong, void function(void*, const(grpc_metadata)*, c_ulong, const(grpc_metadata)*, c_ulong, grpc_status_code, const(char)*), void*) process;
        void function(void*) destroy;
        void* state;
    }
    void grpc_server_credentials_set_auth_metadata_processor(grpc_server_credentials*, grpc_auth_metadata_processor) @nogc nothrow;
    struct grpc_alts_credentials_options;
    grpc_alts_credentials_options* grpc_alts_credentials_client_options_create() @nogc nothrow;
    grpc_alts_credentials_options* grpc_alts_credentials_server_options_create() @nogc nothrow;
    void grpc_alts_credentials_client_options_add_target_service_account(grpc_alts_credentials_options*, const(char)*) @nogc nothrow;
    void grpc_alts_credentials_options_destroy(grpc_alts_credentials_options*) @nogc nothrow;
    grpc_channel_credentials* grpc_alts_credentials_create(const(grpc_alts_credentials_options)*) @nogc nothrow;
    grpc_server_credentials* grpc_alts_server_credentials_create(const(grpc_alts_credentials_options)*) @nogc nothrow;
    grpc_channel_credentials* grpc_local_credentials_create(grpc_local_connect_type) @nogc nothrow;
    grpc_server_credentials* grpc_local_server_credentials_create(grpc_local_connect_type) @nogc nothrow;
    struct grpc_tls_key_materials_config;
    struct grpc_tls_credential_reload_config;
    struct grpc_tls_server_authorization_check_config;
    struct grpc_tls_credentials_options;
    grpc_tls_credentials_options* grpc_tls_credentials_options_create() @nogc nothrow;
    int grpc_tls_credentials_options_set_cert_request_type(grpc_tls_credentials_options*, grpc_ssl_client_certificate_request_type) @nogc nothrow;
    int grpc_tls_credentials_options_set_server_verification_option(grpc_tls_credentials_options*, grpc_tls_server_verification_option) @nogc nothrow;
    int grpc_tls_credentials_options_set_key_materials_config(grpc_tls_credentials_options*, grpc_tls_key_materials_config*) @nogc nothrow;
    int grpc_tls_credentials_options_set_credential_reload_config(grpc_tls_credentials_options*, grpc_tls_credential_reload_config*) @nogc nothrow;
    int grpc_tls_credentials_options_set_server_authorization_check_config(grpc_tls_credentials_options*, grpc_tls_server_authorization_check_config*) @nogc nothrow;
    grpc_tls_key_materials_config* grpc_tls_key_materials_config_create() @nogc nothrow;
    int grpc_tls_key_materials_config_set_key_materials(grpc_tls_key_materials_config*, const(char)*, const(grpc_ssl_pem_key_cert_pair)**, c_ulong) @nogc nothrow;
    int grpc_tls_key_materials_config_set_version(grpc_tls_key_materials_config*, int) @nogc nothrow;
    int grpc_tls_key_materials_config_get_version(grpc_tls_key_materials_config*) @nogc nothrow;
    struct grpc_tls_credential_reload_arg
    {
        void function(grpc_tls_credential_reload_arg*) cb;
        void* cb_user_data;
        grpc_tls_key_materials_config* key_materials_config;
        grpc_ssl_certificate_config_reload_status status;
        const(char)* error_details;
        grpc_tls_credential_reload_config* config;
        void* context;
        void function(void*) destroy_context;
    }
    alias grpc_tls_on_credential_reload_done_cb = void function(grpc_tls_credential_reload_arg*);
    grpc_tls_credential_reload_config* grpc_tls_credential_reload_config_create(const(void)*, int function(void*, grpc_tls_credential_reload_arg*), void function(void*, grpc_tls_credential_reload_arg*), void function(void*)) @nogc nothrow;
    struct grpc_tls_server_authorization_check_arg
    {
        void function(grpc_tls_server_authorization_check_arg*) cb;
        void* cb_user_data;
        int success;
        const(char)* target_name;
        const(char)* peer_cert;
        const(char)* peer_cert_full_chain;
        grpc_status_code status;
        const(char)* error_details;
        grpc_tls_server_authorization_check_config* config;
        void* context;
        void function(void*) destroy_context;
    }
    alias grpc_tls_on_server_authorization_check_done_cb = void function(grpc_tls_server_authorization_check_arg*);
    grpc_tls_server_authorization_check_config* grpc_tls_server_authorization_check_config_create(const(void)*, int function(void*, grpc_tls_server_authorization_check_arg*), void function(void*, grpc_tls_server_authorization_check_arg*), void function(void*)) @nogc nothrow;
    grpc_channel_credentials* grpc_tls_credentials_create(grpc_tls_credentials_options*) @nogc nothrow;
    grpc_server_credentials* grpc_tls_server_credentials_create(grpc_tls_credentials_options*) @nogc nothrow;
    int strfromf64(char*, c_ulong, const(char)*, double) @nogc nothrow;
    alias grpc_ssl_roots_override_result = _Anonymous_18;
    enum _Anonymous_18
    {
        GRPC_SSL_ROOTS_OVERRIDE_OK = 0,
        GRPC_SSL_ROOTS_OVERRIDE_FAIL_PERMANENTLY = 1,
        GRPC_SSL_ROOTS_OVERRIDE_FAIL = 2,
    }
    enum GRPC_SSL_ROOTS_OVERRIDE_OK = _Anonymous_18.GRPC_SSL_ROOTS_OVERRIDE_OK;
    enum GRPC_SSL_ROOTS_OVERRIDE_FAIL_PERMANENTLY = _Anonymous_18.GRPC_SSL_ROOTS_OVERRIDE_FAIL_PERMANENTLY;
    enum GRPC_SSL_ROOTS_OVERRIDE_FAIL = _Anonymous_18.GRPC_SSL_ROOTS_OVERRIDE_FAIL;
    alias grpc_ssl_certificate_config_reload_status = _Anonymous_19;
    enum _Anonymous_19
    {
        GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_UNCHANGED = 0,
        GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_NEW = 1,
        GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_FAIL = 2,
    }
    enum GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_UNCHANGED = _Anonymous_19.GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_UNCHANGED;
    enum GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_NEW = _Anonymous_19.GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_NEW;
    enum GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_FAIL = _Anonymous_19.GRPC_SSL_CERTIFICATE_CONFIG_RELOAD_FAIL;
    alias grpc_ssl_client_certificate_request_type = _Anonymous_20;
    enum _Anonymous_20
    {
        GRPC_SSL_DONT_REQUEST_CLIENT_CERTIFICATE = 0,
        GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_BUT_DONT_VERIFY = 1,
        GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_AND_VERIFY = 2,
        GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_BUT_DONT_VERIFY = 3,
        GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_AND_VERIFY = 4,
    }
    enum GRPC_SSL_DONT_REQUEST_CLIENT_CERTIFICATE = _Anonymous_20.GRPC_SSL_DONT_REQUEST_CLIENT_CERTIFICATE;
    enum GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_BUT_DONT_VERIFY = _Anonymous_20.GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_BUT_DONT_VERIFY;
    enum GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_AND_VERIFY = _Anonymous_20.GRPC_SSL_REQUEST_CLIENT_CERTIFICATE_AND_VERIFY;
    enum GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_BUT_DONT_VERIFY = _Anonymous_20.GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_BUT_DONT_VERIFY;
    enum GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_AND_VERIFY = _Anonymous_20.GRPC_SSL_REQUEST_AND_REQUIRE_CLIENT_CERTIFICATE_AND_VERIFY;
    alias grpc_security_level = _Anonymous_21;
    enum _Anonymous_21
    {
        GRPC_SECURITY_MIN = 0,
        GRPC_SECURITY_NONE = 0,
        GRPC_INTEGRITY_ONLY = 1,
        GRPC_PRIVACY_AND_INTEGRITY = 2,
        GRPC_SECURITY_MAX = 2,
    }
    enum GRPC_SECURITY_MIN = _Anonymous_21.GRPC_SECURITY_MIN;
    enum GRPC_SECURITY_NONE = _Anonymous_21.GRPC_SECURITY_NONE;
    enum GRPC_INTEGRITY_ONLY = _Anonymous_21.GRPC_INTEGRITY_ONLY;
    enum GRPC_PRIVACY_AND_INTEGRITY = _Anonymous_21.GRPC_PRIVACY_AND_INTEGRITY;
    enum GRPC_SECURITY_MAX = _Anonymous_21.GRPC_SECURITY_MAX;
    alias grpc_tls_server_verification_option = _Anonymous_22;
    enum _Anonymous_22
    {
        GRPC_TLS_SERVER_VERIFICATION = 0,
        GRPC_TLS_SKIP_HOSTNAME_VERIFICATION = 1,
        GRPC_TLS_SKIP_ALL_SERVER_VERIFICATION = 2,
    }
    enum GRPC_TLS_SERVER_VERIFICATION = _Anonymous_22.GRPC_TLS_SERVER_VERIFICATION;
    enum GRPC_TLS_SKIP_HOSTNAME_VERIFICATION = _Anonymous_22.GRPC_TLS_SKIP_HOSTNAME_VERIFICATION;
    enum GRPC_TLS_SKIP_ALL_SERVER_VERIFICATION = _Anonymous_22.GRPC_TLS_SKIP_ALL_SERVER_VERIFICATION;
    alias grpc_local_connect_type = _Anonymous_23;
    enum _Anonymous_23
    {
        UDS = 0,
        LOCAL_TCP = 1,
    }
    enum UDS = _Anonymous_23.UDS;
    enum LOCAL_TCP = _Anonymous_23.LOCAL_TCP;
    int strfromf32(char*, c_ulong, const(char)*, float) @nogc nothrow;
    c_long gpr_atm_no_barrier_clamped_add(c_long*, c_long, c_long, c_long) @nogc nothrow;
    alias gpr_atm = c_long;
    int strfroml(char*, c_ulong, const(char)*, real) @nogc nothrow;
    int strfromf(char*, c_ulong, const(char)*, float) @nogc nothrow;
    static int gpr_atm_no_barrier_cas(c_long*, c_long, c_long) @nogc nothrow;
    static int gpr_atm_acq_cas(c_long*, c_long, c_long) @nogc nothrow;
    static int gpr_atm_rel_cas(c_long*, c_long, c_long) @nogc nothrow;
    static int gpr_atm_full_cas(c_long*, c_long, c_long) @nogc nothrow;
    int strfromd(char*, c_ulong, const(char)*, double) @nogc nothrow;
    grpc_byte_buffer* grpc_raw_byte_buffer_create(grpc_slice*, c_ulong) @nogc nothrow;
    grpc_byte_buffer* grpc_raw_compressed_byte_buffer_create(grpc_slice*, c_ulong, grpc_compression_algorithm) @nogc nothrow;
    grpc_byte_buffer* grpc_byte_buffer_copy(grpc_byte_buffer*) @nogc nothrow;
    c_ulong grpc_byte_buffer_length(grpc_byte_buffer*) @nogc nothrow;
    void grpc_byte_buffer_destroy(grpc_byte_buffer*) @nogc nothrow;
    int grpc_byte_buffer_reader_init(grpc_byte_buffer_reader*, grpc_byte_buffer*) @nogc nothrow;
    void grpc_byte_buffer_reader_destroy(grpc_byte_buffer_reader*) @nogc nothrow;
    int grpc_byte_buffer_reader_next(grpc_byte_buffer_reader*, grpc_slice*) @nogc nothrow;
    int grpc_byte_buffer_reader_peek(grpc_byte_buffer_reader*, grpc_slice**) @nogc nothrow;
    grpc_slice grpc_byte_buffer_reader_readall(grpc_byte_buffer_reader*) @nogc nothrow;
    grpc_byte_buffer* grpc_raw_byte_buffer_from_reader(grpc_byte_buffer_reader*) @nogc nothrow;
    struct grpc_byte_buffer
    {
        void* reserved;
        grpc_byte_buffer_type type;
        union grpc_byte_buffer_data
        {
            static struct _Anonymous_24
            {
                void*[8] reserved;
            }
            _Anonymous_24 reserved;
            struct grpc_compressed_buffer
            {
                grpc_compression_algorithm compression;
                grpc_slice_buffer slice_buffer;
            }
            grpc_compressed_buffer raw;
        }
        grpc_byte_buffer_data data;
    }
    struct grpc_byte_buffer_reader
    {
        grpc_byte_buffer* buffer_in;
        grpc_byte_buffer* buffer_out;
        union grpc_byte_buffer_reader_current
        {
            uint index;
        }
        grpc_byte_buffer_reader_current current;
    }
    ulong strtoull(const(char)*, char**, int) @nogc nothrow;
    long strtoll(const(char)*, char**, int) @nogc nothrow;
    alias grpc_compression_algorithm = _Anonymous_25;
    enum _Anonymous_25
    {
        GRPC_COMPRESS_NONE = 0,
        GRPC_COMPRESS_DEFLATE = 1,
        GRPC_COMPRESS_GZIP = 2,
        GRPC_COMPRESS_STREAM_GZIP = 3,
        GRPC_COMPRESS_ALGORITHMS_COUNT = 4,
    }
    enum GRPC_COMPRESS_NONE = _Anonymous_25.GRPC_COMPRESS_NONE;
    enum GRPC_COMPRESS_DEFLATE = _Anonymous_25.GRPC_COMPRESS_DEFLATE;
    enum GRPC_COMPRESS_GZIP = _Anonymous_25.GRPC_COMPRESS_GZIP;
    enum GRPC_COMPRESS_STREAM_GZIP = _Anonymous_25.GRPC_COMPRESS_STREAM_GZIP;
    enum GRPC_COMPRESS_ALGORITHMS_COUNT = _Anonymous_25.GRPC_COMPRESS_ALGORITHMS_COUNT;
    alias grpc_compression_level = _Anonymous_26;
    enum _Anonymous_26
    {
        GRPC_COMPRESS_LEVEL_NONE = 0,
        GRPC_COMPRESS_LEVEL_LOW = 1,
        GRPC_COMPRESS_LEVEL_MED = 2,
        GRPC_COMPRESS_LEVEL_HIGH = 3,
        GRPC_COMPRESS_LEVEL_COUNT = 4,
    }
    enum GRPC_COMPRESS_LEVEL_NONE = _Anonymous_26.GRPC_COMPRESS_LEVEL_NONE;
    enum GRPC_COMPRESS_LEVEL_LOW = _Anonymous_26.GRPC_COMPRESS_LEVEL_LOW;
    enum GRPC_COMPRESS_LEVEL_MED = _Anonymous_26.GRPC_COMPRESS_LEVEL_MED;
    enum GRPC_COMPRESS_LEVEL_HIGH = _Anonymous_26.GRPC_COMPRESS_LEVEL_HIGH;
    enum GRPC_COMPRESS_LEVEL_COUNT = _Anonymous_26.GRPC_COMPRESS_LEVEL_COUNT;
    struct grpc_compression_options
    {
        uint enabled_algorithms_bitset;
        struct grpc_compression_options_default_level
        {
            int is_set;
            grpc_compression_level level;
        }
        grpc_compression_options_default_level default_level;
        struct grpc_compression_options_default_algorithm
        {
            int is_set;
            grpc_compression_algorithm algorithm;
        }
        grpc_compression_options_default_algorithm default_algorithm;
    }
    alias grpc_connectivity_state = _Anonymous_27;
    enum _Anonymous_27
    {
        GRPC_CHANNEL_IDLE = 0,
        GRPC_CHANNEL_CONNECTING = 1,
        GRPC_CHANNEL_READY = 2,
        GRPC_CHANNEL_TRANSIENT_FAILURE = 3,
        GRPC_CHANNEL_SHUTDOWN = 4,
    }
    enum GRPC_CHANNEL_IDLE = _Anonymous_27.GRPC_CHANNEL_IDLE;
    enum GRPC_CHANNEL_CONNECTING = _Anonymous_27.GRPC_CHANNEL_CONNECTING;
    enum GRPC_CHANNEL_READY = _Anonymous_27.GRPC_CHANNEL_READY;
    enum GRPC_CHANNEL_TRANSIENT_FAILURE = _Anonymous_27.GRPC_CHANNEL_TRANSIENT_FAILURE;
    enum GRPC_CHANNEL_SHUTDOWN = _Anonymous_27.GRPC_CHANNEL_SHUTDOWN;
    ulong strtouq(const(char)*, char**, int) @nogc nothrow;
    long strtoq(const(char)*, char**, int) @nogc nothrow;
    c_ulong strtoul(const(char)*, char**, int) @nogc nothrow;
    c_long strtol(const(char)*, char**, int) @nogc nothrow;
    real strtof64x(const(char)*, char**) @nogc nothrow;
    double strtof32x(const(char)*, char**) @nogc nothrow;
    double strtof64(const(char)*, char**) @nogc nothrow;
    float strtof32(const(char)*, char**) @nogc nothrow;
    alias gpr_clock_type = _Anonymous_28;
    enum _Anonymous_28
    {
        GPR_CLOCK_MONOTONIC = 0,
        GPR_CLOCK_REALTIME = 1,
        GPR_CLOCK_PRECISE = 2,
        GPR_TIMESPAN = 3,
    }
    enum GPR_CLOCK_MONOTONIC = _Anonymous_28.GPR_CLOCK_MONOTONIC;
    enum GPR_CLOCK_REALTIME = _Anonymous_28.GPR_CLOCK_REALTIME;
    enum GPR_CLOCK_PRECISE = _Anonymous_28.GPR_CLOCK_PRECISE;
    enum GPR_TIMESPAN = _Anonymous_28.GPR_TIMESPAN;
    struct gpr_timespec
    {
        c_long tv_sec;
        int tv_nsec;
        gpr_clock_type clock_type;
    }
    alias grpc_byte_buffer_type = _Anonymous_29;
    enum _Anonymous_29
    {
        GRPC_BB_RAW = 0,
    }
    enum GRPC_BB_RAW = _Anonymous_29.GRPC_BB_RAW;
    struct grpc_completion_queue;
    struct grpc_alarm;
    struct grpc_channel;
    struct grpc_server;
    struct grpc_call;
    struct grpc_socket_mutator;
    struct grpc_socket_factory;
    alias grpc_arg_type = _Anonymous_30;
    enum _Anonymous_30
    {
        GRPC_ARG_STRING = 0,
        GRPC_ARG_INTEGER = 1,
        GRPC_ARG_POINTER = 2,
    }
    enum GRPC_ARG_STRING = _Anonymous_30.GRPC_ARG_STRING;
    enum GRPC_ARG_INTEGER = _Anonymous_30.GRPC_ARG_INTEGER;
    enum GRPC_ARG_POINTER = _Anonymous_30.GRPC_ARG_POINTER;
    struct grpc_arg_pointer_vtable
    {
        void* function(void*) copy;
        void function(void*) destroy;
        int function(void*, void*) cmp;
    }
    struct grpc_arg
    {
        grpc_arg_type type;
        char* key;
        union grpc_arg_value
        {
            char* string;
            int integer;
            struct grpc_arg_pointer
            {
                void* p;
                const(grpc_arg_pointer_vtable)* vtable;
            }
            grpc_arg_pointer pointer;
        }
        grpc_arg_value value;
    }
    struct grpc_channel_args
    {
        c_ulong num_args;
        grpc_arg* args;
    }
    real strtold(const(char)*, char**) @nogc nothrow;
    float strtof(const(char)*, char**) @nogc nothrow;
    double strtod(const(char)*, char**) @nogc nothrow;
    long atoll(const(char)*) @nogc nothrow;
    c_long atol(const(char)*) @nogc nothrow;
    int atoi(const(char)*) @nogc nothrow;
    double atof(const(char)*) @nogc nothrow;
    c_ulong __ctype_get_mb_cur_max() @nogc nothrow;
    struct lldiv_t
    {
        long quot;
        long rem;
    }
    struct ldiv_t
    {
        c_long quot;
        c_long rem;
    }
    struct div_t
    {
        int quot;
        int rem;
    }
    alias uintmax_t = c_ulong;
    alias intmax_t = c_long;
    alias uintptr_t = c_ulong;
    alias intptr_t = c_long;
    alias uint_fast64_t = c_ulong;
    alias uint_fast32_t = c_ulong;
    alias uint_fast16_t = c_ulong;
    alias uint_fast8_t = ubyte;
    alias int_fast64_t = c_long;
    alias int_fast32_t = c_long;
    alias int_fast16_t = c_long;
    alias int_fast8_t = byte;
    enum grpc_call_error
    {
        GRPC_CALL_OK = 0,
        GRPC_CALL_ERROR = 1,
        GRPC_CALL_ERROR_NOT_ON_SERVER = 2,
        GRPC_CALL_ERROR_NOT_ON_CLIENT = 3,
        GRPC_CALL_ERROR_ALREADY_ACCEPTED = 4,
        GRPC_CALL_ERROR_ALREADY_INVOKED = 5,
        GRPC_CALL_ERROR_NOT_INVOKED = 6,
        GRPC_CALL_ERROR_ALREADY_FINISHED = 7,
        GRPC_CALL_ERROR_TOO_MANY_OPERATIONS = 8,
        GRPC_CALL_ERROR_INVALID_FLAGS = 9,
        GRPC_CALL_ERROR_INVALID_METADATA = 10,
        GRPC_CALL_ERROR_INVALID_MESSAGE = 11,
        GRPC_CALL_ERROR_NOT_SERVER_COMPLETION_QUEUE = 12,
        GRPC_CALL_ERROR_BATCH_TOO_BIG = 13,
        GRPC_CALL_ERROR_PAYLOAD_TYPE_MISMATCH = 14,
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
    alias uint_least64_t = c_ulong;
    alias uint_least32_t = uint;
    alias uint_least16_t = ushort;
    alias uint_least8_t = ubyte;
    alias int_least64_t = c_long;
    alias int_least32_t = int;
    alias int_least16_t = short;
    alias int_least8_t = byte;
    struct grpc_metadata
    {
        grpc_slice key;
        grpc_slice value;
        uint flags;
        static struct _Anonymous_31
        {
            void*[4] obfuscated;
        }
        _Anonymous_31 internal_data;
    }
    enum grpc_completion_type
    {
        GRPC_QUEUE_SHUTDOWN = 0,
        GRPC_QUEUE_TIMEOUT = 1,
        GRPC_OP_COMPLETE = 2,
    }
    enum GRPC_QUEUE_SHUTDOWN = grpc_completion_type.GRPC_QUEUE_SHUTDOWN;
    enum GRPC_QUEUE_TIMEOUT = grpc_completion_type.GRPC_QUEUE_TIMEOUT;
    enum GRPC_OP_COMPLETE = grpc_completion_type.GRPC_OP_COMPLETE;
    struct grpc_event
    {
        grpc_completion_type type;
        int success;
        void* tag;
    }
    struct grpc_metadata_array
    {
        c_ulong count;
        c_ulong capacity;
        grpc_metadata* metadata;
    }
    struct grpc_call_details
    {
        grpc_slice method;
        grpc_slice host;
        gpr_timespec deadline;
        uint flags;
        void* reserved;
    }
    alias grpc_op_type = _Anonymous_32;
    enum _Anonymous_32
    {
        GRPC_OP_SEND_INITIAL_METADATA = 0,
        GRPC_OP_SEND_MESSAGE = 1,
        GRPC_OP_SEND_CLOSE_FROM_CLIENT = 2,
        GRPC_OP_SEND_STATUS_FROM_SERVER = 3,
        GRPC_OP_RECV_INITIAL_METADATA = 4,
        GRPC_OP_RECV_MESSAGE = 5,
        GRPC_OP_RECV_STATUS_ON_CLIENT = 6,
        GRPC_OP_RECV_CLOSE_ON_SERVER = 7,
    }
    enum GRPC_OP_SEND_INITIAL_METADATA = _Anonymous_32.GRPC_OP_SEND_INITIAL_METADATA;
    enum GRPC_OP_SEND_MESSAGE = _Anonymous_32.GRPC_OP_SEND_MESSAGE;
    enum GRPC_OP_SEND_CLOSE_FROM_CLIENT = _Anonymous_32.GRPC_OP_SEND_CLOSE_FROM_CLIENT;
    enum GRPC_OP_SEND_STATUS_FROM_SERVER = _Anonymous_32.GRPC_OP_SEND_STATUS_FROM_SERVER;
    enum GRPC_OP_RECV_INITIAL_METADATA = _Anonymous_32.GRPC_OP_RECV_INITIAL_METADATA;
    enum GRPC_OP_RECV_MESSAGE = _Anonymous_32.GRPC_OP_RECV_MESSAGE;
    enum GRPC_OP_RECV_STATUS_ON_CLIENT = _Anonymous_32.GRPC_OP_RECV_STATUS_ON_CLIENT;
    enum GRPC_OP_RECV_CLOSE_ON_SERVER = _Anonymous_32.GRPC_OP_RECV_CLOSE_ON_SERVER;
    struct grpc_op
    {
        grpc_op_type op;
        uint flags;
        void* reserved;
        union grpc_op_data
        {
            static struct _Anonymous_33
            {
                void*[8] reserved;
            }
            _Anonymous_33 reserved;
            struct grpc_op_send_initial_metadata
            {
                c_ulong count;
                grpc_metadata* metadata;
                struct grpc_op_send_initial_metadata_maybe_compression_level
                {
                    ubyte is_set;
                    grpc_compression_level level;
                }
                grpc_op_send_initial_metadata_maybe_compression_level maybe_compression_level;
            }
            grpc_op_send_initial_metadata send_initial_metadata;
            struct grpc_op_send_message
            {
                grpc_byte_buffer* send_message;
            }
            grpc_op_send_message send_message;
            struct grpc_op_send_status_from_server
            {
                c_ulong trailing_metadata_count;
                grpc_metadata* trailing_metadata;
                grpc_status_code status;
                grpc_slice* status_details;
            }
            grpc_op_send_status_from_server send_status_from_server;
            struct grpc_op_recv_initial_metadata
            {
                grpc_metadata_array* recv_initial_metadata;
            }
            grpc_op_recv_initial_metadata recv_initial_metadata;
            struct grpc_op_recv_message
            {
                grpc_byte_buffer** recv_message;
            }
            grpc_op_recv_message recv_message;
            struct grpc_op_recv_status_on_client
            {
                grpc_metadata_array* trailing_metadata;
                grpc_status_code* status;
                grpc_slice* status_details;
                const(char)** error_string;
            }
            grpc_op_recv_status_on_client recv_status_on_client;
            struct grpc_op_recv_close_on_server
            {
                int* cancelled;
            }
            grpc_op_recv_close_on_server recv_close_on_server;
        }
        grpc_op_data data;
    }
    struct grpc_channel_info
    {
        char** lb_policy_name;
        char** service_config_json;
    }
    struct grpc_resource_quota;
    alias grpc_cq_polling_type = _Anonymous_34;
    enum _Anonymous_34
    {
        GRPC_CQ_DEFAULT_POLLING = 0,
        GRPC_CQ_NON_LISTENING = 1,
        GRPC_CQ_NON_POLLING = 2,
    }
    enum GRPC_CQ_DEFAULT_POLLING = _Anonymous_34.GRPC_CQ_DEFAULT_POLLING;
    enum GRPC_CQ_NON_LISTENING = _Anonymous_34.GRPC_CQ_NON_LISTENING;
    enum GRPC_CQ_NON_POLLING = _Anonymous_34.GRPC_CQ_NON_POLLING;
    alias grpc_cq_completion_type = _Anonymous_35;
    enum _Anonymous_35
    {
        GRPC_CQ_NEXT = 0,
        GRPC_CQ_PLUCK = 1,
        GRPC_CQ_CALLBACK = 2,
    }
    enum GRPC_CQ_NEXT = _Anonymous_35.GRPC_CQ_NEXT;
    enum GRPC_CQ_PLUCK = _Anonymous_35.GRPC_CQ_PLUCK;
    enum GRPC_CQ_CALLBACK = _Anonymous_35.GRPC_CQ_CALLBACK;
    struct grpc_experimental_completion_queue_functor
    {
        void function(grpc_experimental_completion_queue_functor*, int) functor_run;
        int inlineable;
        int internal_success;
        grpc_experimental_completion_queue_functor* internal_next;
    }
    struct grpc_completion_queue_attributes
    {
        int version_;
        grpc_cq_completion_type cq_completion_type;
        grpc_cq_polling_type cq_polling_type;
        grpc_experimental_completion_queue_functor* cq_shutdown_cb;
    }
    struct grpc_completion_queue_factory;
    enum gpr_log_severity
    {
        GPR_LOG_SEVERITY_DEBUG = 0,
        GPR_LOG_SEVERITY_INFO = 1,
        GPR_LOG_SEVERITY_ERROR = 2,
    }
    enum GPR_LOG_SEVERITY_DEBUG = gpr_log_severity.GPR_LOG_SEVERITY_DEBUG;
    enum GPR_LOG_SEVERITY_INFO = gpr_log_severity.GPR_LOG_SEVERITY_INFO;
    enum GPR_LOG_SEVERITY_ERROR = gpr_log_severity.GPR_LOG_SEVERITY_ERROR;
    const(char)* gpr_log_severity_string(gpr_log_severity) @nogc nothrow;
    int sched_getaffinity(int, c_ulong, cpu_set_t*) @nogc nothrow;
    int sched_setaffinity(int, c_ulong, const(cpu_set_t)*) @nogc nothrow;
    void gpr_log(const(char)*, int, gpr_log_severity, const(char)*, ...) @nogc nothrow;
    int gpr_should_log(gpr_log_severity) @nogc nothrow;
    void gpr_log_message(const(char)*, int, gpr_log_severity, const(char)*) @nogc nothrow;
    void gpr_set_log_verbosity(gpr_log_severity) @nogc nothrow;
    void gpr_log_verbosity_init() @nogc nothrow;
    struct gpr_log_func_args
    {
        const(char)* file;
        int line;
        gpr_log_severity severity;
        const(char)* message;
    }
    alias gpr_log_func = void function(gpr_log_func_args*);
    void gpr_set_log_function(void function(gpr_log_func_args*)) @nogc nothrow;
    int sched_rr_get_interval(int, timespec*) @nogc nothrow;
    int sched_get_priority_min(int) @nogc nothrow;
    int sched_get_priority_max(int) @nogc nothrow;
    int sched_yield() @nogc nothrow;
    int sched_getscheduler(int) @nogc nothrow;
    int sched_setscheduler(int, int, const(sched_param)*) @nogc nothrow;
    int sched_getparam(int, sched_param*) @nogc nothrow;
    int sched_setparam(int, const(sched_param)*) @nogc nothrow;
    alias pid_t = int;
    int pthread_atfork(void function(), void function(), void function()) @nogc nothrow;
    int pthread_getcpuclockid(c_ulong, int*) @nogc nothrow;
    int pthread_setspecific(uint, const(void)*) @nogc nothrow;
    void* pthread_getspecific(uint) @nogc nothrow;
    int pthread_key_delete(uint) @nogc nothrow;
    int pthread_key_create(uint*, void function(void*)) @nogc nothrow;
    int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int) @nogc nothrow;
    int pthread_barrierattr_getpshared(const(pthread_barrierattr_t)*, int*) @nogc nothrow;
    int pthread_barrierattr_destroy(pthread_barrierattr_t*) @nogc nothrow;
    int pthread_barrierattr_init(pthread_barrierattr_t*) @nogc nothrow;
    int pthread_barrier_wait(pthread_barrier_t*) @nogc nothrow;
    struct grpc_slice
    {
        grpc_slice_refcount* refcount;
        union grpc_slice_data
        {
            struct grpc_slice_refcounted
            {
                c_ulong length;
                ubyte* bytes;
            }
            grpc_slice_refcounted refcounted;
            struct grpc_slice_inlined
            {
                ubyte length;
                ubyte[23] bytes;
            }
            grpc_slice_inlined inlined;
        }
        grpc_slice_data data;
    }
    struct grpc_slice_refcount;
    int pthread_barrier_destroy(pthread_barrier_t*) @nogc nothrow;
    struct grpc_slice_buffer
    {
        grpc_slice* base_slices;
        grpc_slice* slices;
        c_ulong count;
        c_ulong capacity;
        c_ulong length;
        grpc_slice[8] inlined;
    }
    int pthread_barrier_init(pthread_barrier_t*, const(pthread_barrierattr_t)*, uint) @nogc nothrow;
    int pthread_spin_unlock(int*) @nogc nothrow;
    int pthread_spin_trylock(int*) @nogc nothrow;
    alias grpc_status_code = _Anonymous_36;
    enum _Anonymous_36
    {
        GRPC_STATUS_OK = 0,
        GRPC_STATUS_CANCELLED = 1,
        GRPC_STATUS_UNKNOWN = 2,
        GRPC_STATUS_INVALID_ARGUMENT = 3,
        GRPC_STATUS_DEADLINE_EXCEEDED = 4,
        GRPC_STATUS_NOT_FOUND = 5,
        GRPC_STATUS_ALREADY_EXISTS = 6,
        GRPC_STATUS_PERMISSION_DENIED = 7,
        GRPC_STATUS_UNAUTHENTICATED = 16,
        GRPC_STATUS_RESOURCE_EXHAUSTED = 8,
        GRPC_STATUS_FAILED_PRECONDITION = 9,
        GRPC_STATUS_ABORTED = 10,
        GRPC_STATUS_OUT_OF_RANGE = 11,
        GRPC_STATUS_UNIMPLEMENTED = 12,
        GRPC_STATUS_INTERNAL = 13,
        GRPC_STATUS_UNAVAILABLE = 14,
        GRPC_STATUS_DATA_LOSS = 15,
        GRPC_STATUS__DO_NOT_USE = -1,
    }
    enum GRPC_STATUS_OK = _Anonymous_36.GRPC_STATUS_OK;
    enum GRPC_STATUS_CANCELLED = _Anonymous_36.GRPC_STATUS_CANCELLED;
    enum GRPC_STATUS_UNKNOWN = _Anonymous_36.GRPC_STATUS_UNKNOWN;
    enum GRPC_STATUS_INVALID_ARGUMENT = _Anonymous_36.GRPC_STATUS_INVALID_ARGUMENT;
    enum GRPC_STATUS_DEADLINE_EXCEEDED = _Anonymous_36.GRPC_STATUS_DEADLINE_EXCEEDED;
    enum GRPC_STATUS_NOT_FOUND = _Anonymous_36.GRPC_STATUS_NOT_FOUND;
    enum GRPC_STATUS_ALREADY_EXISTS = _Anonymous_36.GRPC_STATUS_ALREADY_EXISTS;
    enum GRPC_STATUS_PERMISSION_DENIED = _Anonymous_36.GRPC_STATUS_PERMISSION_DENIED;
    enum GRPC_STATUS_UNAUTHENTICATED = _Anonymous_36.GRPC_STATUS_UNAUTHENTICATED;
    enum GRPC_STATUS_RESOURCE_EXHAUSTED = _Anonymous_36.GRPC_STATUS_RESOURCE_EXHAUSTED;
    enum GRPC_STATUS_FAILED_PRECONDITION = _Anonymous_36.GRPC_STATUS_FAILED_PRECONDITION;
    enum GRPC_STATUS_ABORTED = _Anonymous_36.GRPC_STATUS_ABORTED;
    enum GRPC_STATUS_OUT_OF_RANGE = _Anonymous_36.GRPC_STATUS_OUT_OF_RANGE;
    enum GRPC_STATUS_UNIMPLEMENTED = _Anonymous_36.GRPC_STATUS_UNIMPLEMENTED;
    enum GRPC_STATUS_INTERNAL = _Anonymous_36.GRPC_STATUS_INTERNAL;
    enum GRPC_STATUS_UNAVAILABLE = _Anonymous_36.GRPC_STATUS_UNAVAILABLE;
    enum GRPC_STATUS_DATA_LOSS = _Anonymous_36.GRPC_STATUS_DATA_LOSS;
    enum GRPC_STATUS__DO_NOT_USE = _Anonymous_36.GRPC_STATUS__DO_NOT_USE;
    int pthread_spin_lock(int*) @nogc nothrow;
    struct gpr_event
    {
        c_long state;
    }
    struct gpr_refcount
    {
        c_long count;
    }
    struct gpr_stats_counter
    {
        c_long value;
    }
    int pthread_spin_destroy(int*) @nogc nothrow;
    alias gpr_mu = pthread_mutex_t;
    alias gpr_cv = pthread_cond_t;
    alias gpr_once = int;
    int pthread_spin_init(int*, int) @nogc nothrow;
    grpc_slice grpc_slice_ref(grpc_slice) @nogc nothrow;
    void grpc_slice_unref(grpc_slice) @nogc nothrow;
    grpc_slice grpc_slice_copy(grpc_slice) @nogc nothrow;
    grpc_slice grpc_slice_new(void*, c_ulong, void function(void*)) @nogc nothrow;
    grpc_slice grpc_slice_new_with_user_data(void*, c_ulong, void function(void*), void*) @nogc nothrow;
    grpc_slice grpc_slice_new_with_len(void*, c_ulong, void function(void*, c_ulong)) @nogc nothrow;
    grpc_slice grpc_slice_malloc(c_ulong) @nogc nothrow;
    grpc_slice grpc_slice_malloc_large(c_ulong) @nogc nothrow;
    grpc_slice grpc_slice_intern(grpc_slice) @nogc nothrow;
    grpc_slice grpc_slice_from_copied_string(const(char)*) @nogc nothrow;
    grpc_slice grpc_slice_from_copied_buffer(const(char)*, c_ulong) @nogc nothrow;
    grpc_slice grpc_slice_from_static_string(const(char)*) @nogc nothrow;
    grpc_slice grpc_slice_from_static_buffer(const(void)*, c_ulong) @nogc nothrow;
    grpc_slice grpc_slice_sub(grpc_slice, c_ulong, c_ulong) @nogc nothrow;
    grpc_slice grpc_slice_sub_no_ref(grpc_slice, c_ulong, c_ulong) @nogc nothrow;
    grpc_slice grpc_slice_split_tail(grpc_slice*, c_ulong) @nogc nothrow;
    alias grpc_slice_ref_whom = _Anonymous_37;
    enum _Anonymous_37
    {
        GRPC_SLICE_REF_TAIL = 1,
        GRPC_SLICE_REF_HEAD = 2,
        GRPC_SLICE_REF_BOTH = 3,
    }
    enum GRPC_SLICE_REF_TAIL = _Anonymous_37.GRPC_SLICE_REF_TAIL;
    enum GRPC_SLICE_REF_HEAD = _Anonymous_37.GRPC_SLICE_REF_HEAD;
    enum GRPC_SLICE_REF_BOTH = _Anonymous_37.GRPC_SLICE_REF_BOTH;
    grpc_slice grpc_slice_split_tail_maybe_ref(grpc_slice*, c_ulong, grpc_slice_ref_whom) @nogc nothrow;
    grpc_slice grpc_slice_split_head(grpc_slice*, c_ulong) @nogc nothrow;
    grpc_slice grpc_empty_slice() @nogc nothrow;
    uint grpc_slice_default_hash_impl(grpc_slice) @nogc nothrow;
    int grpc_slice_default_eq_impl(grpc_slice, grpc_slice) @nogc nothrow;
    int grpc_slice_eq(grpc_slice, grpc_slice) @nogc nothrow;
    int grpc_slice_cmp(grpc_slice, grpc_slice) @nogc nothrow;
    int grpc_slice_str_cmp(grpc_slice, const(char)*) @nogc nothrow;
    int grpc_slice_buf_start_eq(grpc_slice, const(void)*, c_ulong) @nogc nothrow;
    int grpc_slice_rchr(grpc_slice, char) @nogc nothrow;
    int grpc_slice_chr(grpc_slice, char) @nogc nothrow;
    int grpc_slice_slice(grpc_slice, grpc_slice) @nogc nothrow;
    uint grpc_slice_hash(grpc_slice) @nogc nothrow;
    int grpc_slice_is_equivalent(grpc_slice, grpc_slice) @nogc nothrow;
    grpc_slice grpc_slice_dup(grpc_slice) @nogc nothrow;
    char* grpc_slice_to_c_string(grpc_slice) @nogc nothrow;
    void grpc_slice_buffer_init(grpc_slice_buffer*) @nogc nothrow;
    void grpc_slice_buffer_destroy(grpc_slice_buffer*) @nogc nothrow;
    void grpc_slice_buffer_add(grpc_slice_buffer*, grpc_slice) @nogc nothrow;
    c_ulong grpc_slice_buffer_add_indexed(grpc_slice_buffer*, grpc_slice) @nogc nothrow;
    void grpc_slice_buffer_addn(grpc_slice_buffer*, grpc_slice*, c_ulong) @nogc nothrow;
    ubyte* grpc_slice_buffer_tiny_add(grpc_slice_buffer*, c_ulong) @nogc nothrow;
    void grpc_slice_buffer_pop(grpc_slice_buffer*) @nogc nothrow;
    void grpc_slice_buffer_reset_and_unref(grpc_slice_buffer*) @nogc nothrow;
    void grpc_slice_buffer_swap(grpc_slice_buffer*, grpc_slice_buffer*) @nogc nothrow;
    void grpc_slice_buffer_move_into(grpc_slice_buffer*, grpc_slice_buffer*) @nogc nothrow;
    void grpc_slice_buffer_trim_end(grpc_slice_buffer*, c_ulong, grpc_slice_buffer*) @nogc nothrow;
    void grpc_slice_buffer_move_first(grpc_slice_buffer*, c_ulong, grpc_slice_buffer*) @nogc nothrow;
    void grpc_slice_buffer_move_first_no_ref(grpc_slice_buffer*, c_ulong, grpc_slice_buffer*) @nogc nothrow;
    void grpc_slice_buffer_move_first_into_buffer(grpc_slice_buffer*, c_ulong, void*) @nogc nothrow;
    grpc_slice grpc_slice_buffer_take_first(grpc_slice_buffer*) @nogc nothrow;
    void grpc_slice_buffer_undo_take_first(grpc_slice_buffer*, grpc_slice) @nogc nothrow;
    int pthread_condattr_setclock(pthread_condattr_t*, int) @nogc nothrow;
    void* gpr_malloc(c_ulong) @nogc nothrow;
    void* gpr_zalloc(c_ulong) @nogc nothrow;
    void gpr_free(void*) @nogc nothrow;
    void* gpr_realloc(void*, c_ulong) @nogc nothrow;
    void* gpr_malloc_aligned(c_ulong, c_ulong) @nogc nothrow;
    void gpr_free_aligned(void*) @nogc nothrow;
    int pthread_condattr_getclock(const(pthread_condattr_t)*, int*) @nogc nothrow;
    char* gpr_strdup(const(char)*) @nogc nothrow;
    int gpr_asprintf(char**, const(char)*, ...) @nogc nothrow;
    void gpr_mu_init(pthread_mutex_t*) @nogc nothrow;
    void gpr_mu_destroy(pthread_mutex_t*) @nogc nothrow;
    void gpr_mu_lock(pthread_mutex_t*) @nogc nothrow;
    void gpr_mu_unlock(pthread_mutex_t*) @nogc nothrow;
    int gpr_mu_trylock(pthread_mutex_t*) @nogc nothrow;
    void gpr_cv_init(pthread_cond_t*) @nogc nothrow;
    void gpr_cv_destroy(pthread_cond_t*) @nogc nothrow;
    int gpr_cv_wait(pthread_cond_t*, pthread_mutex_t*, gpr_timespec) @nogc nothrow;
    void gpr_cv_signal(pthread_cond_t*) @nogc nothrow;
    void gpr_cv_broadcast(pthread_cond_t*) @nogc nothrow;
    void gpr_once_init(int*, void function()) @nogc nothrow;
    void gpr_event_init(gpr_event*) @nogc nothrow;
    void gpr_event_set(gpr_event*, void*) @nogc nothrow;
    void* gpr_event_get(gpr_event*) @nogc nothrow;
    void* gpr_event_wait(gpr_event*, gpr_timespec) @nogc nothrow;
    void gpr_ref_init(gpr_refcount*, int) @nogc nothrow;
    void gpr_ref(gpr_refcount*) @nogc nothrow;
    void gpr_ref_non_zero(gpr_refcount*) @nogc nothrow;
    void gpr_refn(gpr_refcount*, int) @nogc nothrow;
    int gpr_unref(gpr_refcount*) @nogc nothrow;
    int gpr_ref_is_unique(gpr_refcount*) @nogc nothrow;
    void gpr_stats_init(gpr_stats_counter*, c_long) @nogc nothrow;
    void gpr_stats_inc(gpr_stats_counter*, c_long) @nogc nothrow;
    c_long gpr_stats_read(const(gpr_stats_counter)*) @nogc nothrow;
    alias gpr_thd_id = c_ulong;
    c_ulong gpr_thd_currentid() @nogc nothrow;
    gpr_timespec gpr_time_0(gpr_clock_type) @nogc nothrow;
    gpr_timespec gpr_inf_future(gpr_clock_type) @nogc nothrow;
    gpr_timespec gpr_inf_past(gpr_clock_type) @nogc nothrow;
    int pthread_condattr_setpshared(pthread_condattr_t*, int) @nogc nothrow;
    int pthread_condattr_getpshared(const(pthread_condattr_t)*, int*) @nogc nothrow;
    void gpr_time_init() @nogc nothrow;
    gpr_timespec gpr_now(gpr_clock_type) @nogc nothrow;
    gpr_timespec gpr_convert_clock_type(gpr_timespec, gpr_clock_type) @nogc nothrow;
    int gpr_time_cmp(gpr_timespec, gpr_timespec) @nogc nothrow;
    gpr_timespec gpr_time_max(gpr_timespec, gpr_timespec) @nogc nothrow;
    gpr_timespec gpr_time_min(gpr_timespec, gpr_timespec) @nogc nothrow;
    gpr_timespec gpr_time_add(gpr_timespec, gpr_timespec) @nogc nothrow;
    gpr_timespec gpr_time_sub(gpr_timespec, gpr_timespec) @nogc nothrow;
    gpr_timespec gpr_time_from_micros(c_long, gpr_clock_type) @nogc nothrow;
    gpr_timespec gpr_time_from_nanos(c_long, gpr_clock_type) @nogc nothrow;
    gpr_timespec gpr_time_from_millis(c_long, gpr_clock_type) @nogc nothrow;
    gpr_timespec gpr_time_from_seconds(c_long, gpr_clock_type) @nogc nothrow;
    gpr_timespec gpr_time_from_minutes(c_long, gpr_clock_type) @nogc nothrow;
    gpr_timespec gpr_time_from_hours(c_long, gpr_clock_type) @nogc nothrow;
    int gpr_time_to_millis(gpr_timespec) @nogc nothrow;
    int gpr_time_similar(gpr_timespec, gpr_timespec, gpr_timespec) @nogc nothrow;
    void gpr_sleep_until(gpr_timespec) @nogc nothrow;
    double gpr_timespec_to_micros(gpr_timespec) @nogc nothrow;
    int pthread_condattr_destroy(pthread_condattr_t*) @nogc nothrow;
    enum _Anonymous_38
    {
        PTHREAD_CREATE_JOINABLE = 0,
        PTHREAD_CREATE_DETACHED = 1,
    }
    enum PTHREAD_CREATE_JOINABLE = _Anonymous_38.PTHREAD_CREATE_JOINABLE;
    enum PTHREAD_CREATE_DETACHED = _Anonymous_38.PTHREAD_CREATE_DETACHED;
    int pthread_condattr_init(pthread_condattr_t*) @nogc nothrow;
    enum _Anonymous_39
    {
        PTHREAD_MUTEX_TIMED_NP = 0,
        PTHREAD_MUTEX_RECURSIVE_NP = 1,
        PTHREAD_MUTEX_ERRORCHECK_NP = 2,
        PTHREAD_MUTEX_ADAPTIVE_NP = 3,
        PTHREAD_MUTEX_NORMAL = 0,
        PTHREAD_MUTEX_RECURSIVE = 1,
        PTHREAD_MUTEX_ERRORCHECK = 2,
        PTHREAD_MUTEX_DEFAULT = 0,
        PTHREAD_MUTEX_FAST_NP = 0,
    }
    enum PTHREAD_MUTEX_TIMED_NP = _Anonymous_39.PTHREAD_MUTEX_TIMED_NP;
    enum PTHREAD_MUTEX_RECURSIVE_NP = _Anonymous_39.PTHREAD_MUTEX_RECURSIVE_NP;
    enum PTHREAD_MUTEX_ERRORCHECK_NP = _Anonymous_39.PTHREAD_MUTEX_ERRORCHECK_NP;
    enum PTHREAD_MUTEX_ADAPTIVE_NP = _Anonymous_39.PTHREAD_MUTEX_ADAPTIVE_NP;
    enum PTHREAD_MUTEX_NORMAL = _Anonymous_39.PTHREAD_MUTEX_NORMAL;
    enum PTHREAD_MUTEX_RECURSIVE = _Anonymous_39.PTHREAD_MUTEX_RECURSIVE;
    enum PTHREAD_MUTEX_ERRORCHECK = _Anonymous_39.PTHREAD_MUTEX_ERRORCHECK;
    enum PTHREAD_MUTEX_DEFAULT = _Anonymous_39.PTHREAD_MUTEX_DEFAULT;
    enum PTHREAD_MUTEX_FAST_NP = _Anonymous_39.PTHREAD_MUTEX_FAST_NP;
    enum _Anonymous_40
    {
        PTHREAD_MUTEX_STALLED = 0,
        PTHREAD_MUTEX_STALLED_NP = 0,
        PTHREAD_MUTEX_ROBUST = 1,
        PTHREAD_MUTEX_ROBUST_NP = 1,
    }
    enum PTHREAD_MUTEX_STALLED = _Anonymous_40.PTHREAD_MUTEX_STALLED;
    enum PTHREAD_MUTEX_STALLED_NP = _Anonymous_40.PTHREAD_MUTEX_STALLED_NP;
    enum PTHREAD_MUTEX_ROBUST = _Anonymous_40.PTHREAD_MUTEX_ROBUST;
    enum PTHREAD_MUTEX_ROBUST_NP = _Anonymous_40.PTHREAD_MUTEX_ROBUST_NP;
    enum _Anonymous_41
    {
        PTHREAD_PRIO_NONE = 0,
        PTHREAD_PRIO_INHERIT = 1,
        PTHREAD_PRIO_PROTECT = 2,
    }
    enum PTHREAD_PRIO_NONE = _Anonymous_41.PTHREAD_PRIO_NONE;
    enum PTHREAD_PRIO_INHERIT = _Anonymous_41.PTHREAD_PRIO_INHERIT;
    enum PTHREAD_PRIO_PROTECT = _Anonymous_41.PTHREAD_PRIO_PROTECT;
    int pthread_cond_clockwait(pthread_cond_t*, pthread_mutex_t*, int, const(timespec)*) @nogc nothrow;
    int pthread_cond_timedwait(pthread_cond_t*, pthread_mutex_t*, const(timespec)*) @nogc nothrow;
    enum _Anonymous_42
    {
        PTHREAD_RWLOCK_PREFER_READER_NP = 0,
        PTHREAD_RWLOCK_PREFER_WRITER_NP = 1,
        PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP = 2,
        PTHREAD_RWLOCK_DEFAULT_NP = 0,
    }
    enum PTHREAD_RWLOCK_PREFER_READER_NP = _Anonymous_42.PTHREAD_RWLOCK_PREFER_READER_NP;
    enum PTHREAD_RWLOCK_PREFER_WRITER_NP = _Anonymous_42.PTHREAD_RWLOCK_PREFER_WRITER_NP;
    enum PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP = _Anonymous_42.PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP;
    enum PTHREAD_RWLOCK_DEFAULT_NP = _Anonymous_42.PTHREAD_RWLOCK_DEFAULT_NP;
    int pthread_cond_wait(pthread_cond_t*, pthread_mutex_t*) @nogc nothrow;
    enum _Anonymous_43
    {
        PTHREAD_INHERIT_SCHED = 0,
        PTHREAD_EXPLICIT_SCHED = 1,
    }
    enum PTHREAD_INHERIT_SCHED = _Anonymous_43.PTHREAD_INHERIT_SCHED;
    enum PTHREAD_EXPLICIT_SCHED = _Anonymous_43.PTHREAD_EXPLICIT_SCHED;
    enum _Anonymous_44
    {
        PTHREAD_SCOPE_SYSTEM = 0,
        PTHREAD_SCOPE_PROCESS = 1,
    }
    enum PTHREAD_SCOPE_SYSTEM = _Anonymous_44.PTHREAD_SCOPE_SYSTEM;
    enum PTHREAD_SCOPE_PROCESS = _Anonymous_44.PTHREAD_SCOPE_PROCESS;
    int pthread_cond_broadcast(pthread_cond_t*) @nogc nothrow;
    enum _Anonymous_45
    {
        PTHREAD_PROCESS_PRIVATE = 0,
        PTHREAD_PROCESS_SHARED = 1,
    }
    enum PTHREAD_PROCESS_PRIVATE = _Anonymous_45.PTHREAD_PROCESS_PRIVATE;
    enum PTHREAD_PROCESS_SHARED = _Anonymous_45.PTHREAD_PROCESS_SHARED;
    int pthread_cond_signal(pthread_cond_t*) @nogc nothrow;
    struct _pthread_cleanup_buffer
    {
        void function(void*) __routine;
        void* __arg;
        int __canceltype;
        _pthread_cleanup_buffer* __prev;
    }
    enum _Anonymous_46
    {
        PTHREAD_CANCEL_ENABLE = 0,
        PTHREAD_CANCEL_DISABLE = 1,
    }
    enum PTHREAD_CANCEL_ENABLE = _Anonymous_46.PTHREAD_CANCEL_ENABLE;
    enum PTHREAD_CANCEL_DISABLE = _Anonymous_46.PTHREAD_CANCEL_DISABLE;
    int pthread_cond_destroy(pthread_cond_t*) @nogc nothrow;
    enum _Anonymous_47
    {
        PTHREAD_CANCEL_DEFERRED = 0,
        PTHREAD_CANCEL_ASYNCHRONOUS = 1,
    }
    enum PTHREAD_CANCEL_DEFERRED = _Anonymous_47.PTHREAD_CANCEL_DEFERRED;
    enum PTHREAD_CANCEL_ASYNCHRONOUS = _Anonymous_47.PTHREAD_CANCEL_ASYNCHRONOUS;
    int pthread_cond_init(pthread_cond_t*, const(pthread_condattr_t)*) @nogc nothrow;
    int pthread_create(c_ulong*, const(pthread_attr_t)*, void* function(void*), void*) @nogc nothrow;
    void pthread_exit(void*) @nogc nothrow;
    int pthread_join(c_ulong, void**) @nogc nothrow;
    int pthread_tryjoin_np(c_ulong, void**) @nogc nothrow;
    int pthread_timedjoin_np(c_ulong, void**, const(timespec)*) @nogc nothrow;
    int pthread_clockjoin_np(c_ulong, void**, int, const(timespec)*) @nogc nothrow;
    int pthread_detach(c_ulong) @nogc nothrow;
    c_ulong pthread_self() @nogc nothrow;
    int pthread_equal(c_ulong, c_ulong) @nogc nothrow;
    int pthread_attr_init(pthread_attr_t*) @nogc nothrow;
    int pthread_attr_destroy(pthread_attr_t*) @nogc nothrow;
    int pthread_attr_getdetachstate(const(pthread_attr_t)*, int*) @nogc nothrow;
    int pthread_attr_setdetachstate(pthread_attr_t*, int) @nogc nothrow;
    int pthread_attr_getguardsize(const(pthread_attr_t)*, c_ulong*) @nogc nothrow;
    int pthread_attr_setguardsize(pthread_attr_t*, c_ulong) @nogc nothrow;
    int pthread_attr_getschedparam(const(pthread_attr_t)*, sched_param*) @nogc nothrow;
    int pthread_attr_setschedparam(pthread_attr_t*, const(sched_param)*) @nogc nothrow;
    int pthread_attr_getschedpolicy(const(pthread_attr_t)*, int*) @nogc nothrow;
    int pthread_attr_setschedpolicy(pthread_attr_t*, int) @nogc nothrow;
    int pthread_attr_getinheritsched(const(pthread_attr_t)*, int*) @nogc nothrow;
    int pthread_attr_setinheritsched(pthread_attr_t*, int) @nogc nothrow;
    int pthread_attr_getscope(const(pthread_attr_t)*, int*) @nogc nothrow;
    int pthread_attr_setscope(pthread_attr_t*, int) @nogc nothrow;
    int pthread_attr_getstackaddr(const(pthread_attr_t)*, void**) @nogc nothrow;
    int pthread_attr_setstackaddr(pthread_attr_t*, void*) @nogc nothrow;
    int pthread_attr_getstacksize(const(pthread_attr_t)*, c_ulong*) @nogc nothrow;
    int pthread_attr_setstacksize(pthread_attr_t*, c_ulong) @nogc nothrow;
    int pthread_attr_getstack(const(pthread_attr_t)*, void**, c_ulong*) @nogc nothrow;
    int pthread_attr_setstack(pthread_attr_t*, void*, c_ulong) @nogc nothrow;
    int pthread_attr_setaffinity_np(pthread_attr_t*, c_ulong, const(cpu_set_t)*) @nogc nothrow;
    int pthread_attr_getaffinity_np(const(pthread_attr_t)*, c_ulong, cpu_set_t*) @nogc nothrow;
    int pthread_getattr_default_np(pthread_attr_t*) @nogc nothrow;
    int pthread_setattr_default_np(const(pthread_attr_t)*) @nogc nothrow;
    int pthread_getattr_np(c_ulong, pthread_attr_t*) @nogc nothrow;
    int pthread_setschedparam(c_ulong, int, const(sched_param)*) @nogc nothrow;
    int pthread_getschedparam(c_ulong, int*, sched_param*) @nogc nothrow;
    int pthread_setschedprio(c_ulong, int) @nogc nothrow;
    int pthread_getname_np(c_ulong, char*, c_ulong) @nogc nothrow;
    int pthread_setname_np(c_ulong, const(char)*) @nogc nothrow;
    int pthread_getconcurrency() @nogc nothrow;
    int pthread_setconcurrency(int) @nogc nothrow;
    int pthread_yield() @nogc nothrow;
    int pthread_setaffinity_np(c_ulong, c_ulong, const(cpu_set_t)*) @nogc nothrow;
    int pthread_getaffinity_np(c_ulong, c_ulong, cpu_set_t*) @nogc nothrow;
    int pthread_once(int*, void function()) @nogc nothrow;
    int pthread_setcancelstate(int, int*) @nogc nothrow;
    int pthread_setcanceltype(int, int*) @nogc nothrow;
    int pthread_cancel(c_ulong) @nogc nothrow;
    void pthread_testcancel() @nogc nothrow;
    struct __pthread_unwind_buf_t
    {
        static struct _Anonymous_48
        {
            c_long[8] __cancel_jmp_buf;
            int __mask_was_saved;
        }
        _Anonymous_48[1] __cancel_jmp_buf;
        void*[4] __pad;
    }
    int pthread_rwlockattr_setkind_np(pthread_rwlockattr_t*, int) @nogc nothrow;
    struct __pthread_cleanup_frame
    {
        void function(void*) __cancel_routine;
        void* __cancel_arg;
        int __do_it;
        int __cancel_type;
    }
    void __pthread_register_cancel(__pthread_unwind_buf_t*) @nogc nothrow;
    void __pthread_unregister_cancel(__pthread_unwind_buf_t*) @nogc nothrow;
    int pthread_rwlockattr_getkind_np(const(pthread_rwlockattr_t)*, int*) @nogc nothrow;
    void __pthread_register_cancel_defer(__pthread_unwind_buf_t*) @nogc nothrow;
    void __pthread_unregister_cancel_restore(__pthread_unwind_buf_t*) @nogc nothrow;
    void __pthread_unwind_next(__pthread_unwind_buf_t*) @nogc nothrow;
    struct __jmp_buf_tag;
    int __sigsetjmp(__jmp_buf_tag*, int) @nogc nothrow;
    int pthread_mutex_init(pthread_mutex_t*, const(pthread_mutexattr_t)*) @nogc nothrow;
    int pthread_mutex_destroy(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutex_trylock(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutex_lock(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutex_timedlock(pthread_mutex_t*, const(timespec)*) @nogc nothrow;
    int pthread_mutex_clocklock(pthread_mutex_t*, int, const(timespec)*) @nogc nothrow;
    int pthread_mutex_unlock(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutex_getprioceiling(const(pthread_mutex_t)*, int*) @nogc nothrow;
    int pthread_mutex_setprioceiling(pthread_mutex_t*, int, int*) @nogc nothrow;
    int pthread_mutex_consistent(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutex_consistent_np(pthread_mutex_t*) @nogc nothrow;
    int pthread_mutexattr_init(pthread_mutexattr_t*) @nogc nothrow;
    int pthread_mutexattr_destroy(pthread_mutexattr_t*) @nogc nothrow;
    int pthread_mutexattr_getpshared(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_mutexattr_gettype(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_mutexattr_getprotocol(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_setprotocol(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_mutexattr_getprioceiling(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_setprioceiling(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_mutexattr_getrobust(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_getrobust_np(const(pthread_mutexattr_t)*, int*) @nogc nothrow;
    int pthread_mutexattr_setrobust(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_mutexattr_setrobust_np(pthread_mutexattr_t*, int) @nogc nothrow;
    int pthread_rwlock_init(pthread_rwlock_t*, const(pthread_rwlockattr_t)*) @nogc nothrow;
    int pthread_rwlock_destroy(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlock_rdlock(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlock_tryrdlock(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlock_timedrdlock(pthread_rwlock_t*, const(timespec)*) @nogc nothrow;
    int pthread_rwlock_clockrdlock(pthread_rwlock_t*, int, const(timespec)*) @nogc nothrow;
    int pthread_rwlock_wrlock(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlock_trywrlock(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlock_timedwrlock(pthread_rwlock_t*, const(timespec)*) @nogc nothrow;
    int pthread_rwlock_clockwrlock(pthread_rwlock_t*, int, const(timespec)*) @nogc nothrow;
    int pthread_rwlock_unlock(pthread_rwlock_t*) @nogc nothrow;
    int pthread_rwlockattr_init(pthread_rwlockattr_t*) @nogc nothrow;
    int pthread_rwlockattr_destroy(pthread_rwlockattr_t*) @nogc nothrow;
    int pthread_rwlockattr_getpshared(const(pthread_rwlockattr_t)*, int*) @nogc nothrow;
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int) @nogc nothrow;
    static if(!is(typeof(PTHREAD_ONCE_INIT))) {
        enum PTHREAD_ONCE_INIT = 0;
    }
    static if(!is(typeof(_PTHREAD_H))) {
        enum _PTHREAD_H = 1;
    }






    static if(!is(typeof(LINUX_VERSION_CODE))) {
        enum LINUX_VERSION_CODE = 328721;
    }




    static if(!is(typeof(GPR_US_PER_MS))) {
        enum GPR_US_PER_MS = 1000;
    }




    static if(!is(typeof(GPR_NS_PER_US))) {
        enum GPR_NS_PER_US = 1000;
    }




    static if(!is(typeof(GPR_NS_PER_MS))) {
        enum GPR_NS_PER_MS = 1000000;
    }




    static if(!is(typeof(GPR_NS_PER_SEC))) {
        enum GPR_NS_PER_SEC = 1000000000;
    }




    static if(!is(typeof(GPR_US_PER_SEC))) {
        enum GPR_US_PER_SEC = 1000000;
    }




    static if(!is(typeof(GPR_MS_PER_SEC))) {
        enum GPR_MS_PER_SEC = 1000;
    }
    static if(!is(typeof(GRPC_SLICE_BUFFER_INLINE_ELEMENTS))) {
        enum GRPC_SLICE_BUFFER_INLINE_ELEMENTS = 8;
    }
    static if(!is(typeof(GRPC_ALLOW_EXCEPTIONS))) {
        enum GRPC_ALLOW_EXCEPTIONS = 0;
    }






    static if(!is(typeof(GPR_HAS_ATTRIBUTE_WEAK))) {
        enum GPR_HAS_ATTRIBUTE_WEAK = 1;
    }






    static if(!is(typeof(GPR_HAS_ATTRIBUTE_NOINLINE))) {
        enum GPR_HAS_ATTRIBUTE_NOINLINE = 1;
    }
    static if(!is(typeof(GRPC_IF_NAMETOINDEX))) {
        enum GRPC_IF_NAMETOINDEX = 1;
    }




    static if(!is(typeof(GRPC_ARES))) {
        enum GRPC_ARES = 1;
    }




    static if(!is(typeof(GPR_MAX_ALIGNMENT))) {
        enum GPR_MAX_ALIGNMENT = 16;
    }






    static if(!is(typeof(GPR_CACHELINE_SIZE_LOG))) {
        enum GPR_CACHELINE_SIZE_LOG = 6;
    }




    static if(!is(typeof(_SCHED_H))) {
        enum _SCHED_H = 1;
    }




    static if(!is(typeof(GPR_CYCLE_COUNTER_FALLBACK))) {
        enum GPR_CYCLE_COUNTER_FALLBACK = 1;
    }
    static if(!is(typeof(GPR_LINUX_PTHREAD_NAME))) {
        enum GPR_LINUX_PTHREAD_NAME = 1;
    }




    static if(!is(typeof(GPR_POSIX_CRASH_HANDLER))) {
        enum GPR_POSIX_CRASH_HANDLER = 1;
    }




    static if(!is(typeof(GPR_ARCH_64))) {
        enum GPR_ARCH_64 = 1;
    }




    static if(!is(typeof(GPR_GETPID_IN_UNISTD_H))) {
        enum GPR_GETPID_IN_UNISTD_H = 1;
    }




    static if(!is(typeof(GPR_HAS_PTHREAD_H))) {
        enum GPR_HAS_PTHREAD_H = 1;
    }






    static if(!is(typeof(GPR_POSIX_TIME))) {
        enum GPR_POSIX_TIME = 1;
    }




    static if(!is(typeof(GPR_POSIX_SYNC))) {
        enum GPR_POSIX_SYNC = 1;
    }
    static if(!is(typeof(GPR_POSIX_SUBPROCESS))) {
        enum GPR_POSIX_SUBPROCESS = 1;
    }




    static if(!is(typeof(GPR_POSIX_STRING))) {
        enum GPR_POSIX_STRING = 1;
    }




    static if(!is(typeof(GPR_POSIX_TMPFILE))) {
        enum GPR_POSIX_TMPFILE = 1;
    }




    static if(!is(typeof(GPR_LINUX_ENV))) {
        enum GPR_LINUX_ENV = 1;
    }




    static if(!is(typeof(GPR_SUPPORT_CHANNELS_FROM_FD))) {
        enum GPR_SUPPORT_CHANNELS_FROM_FD = 1;
    }






    static if(!is(typeof(GPR_LINUX))) {
        enum GPR_LINUX = 1;
    }




    static if(!is(typeof(GPR_GCC_TLS))) {
        enum GPR_GCC_TLS = 1;
    }




    static if(!is(typeof(GPR_GCC_ATOMIC))) {
        enum GPR_GCC_ATOMIC = 1;
    }




    static if(!is(typeof(GPR_CPU_LINUX))) {
        enum GPR_CPU_LINUX = 1;
    }
    static if(!is(typeof(GPR_PLATFORM_STRING))) {
        enum GPR_PLATFORM_STRING = "linux";
    }




    static if(!is(typeof(GRPC_USE_ABSL))) {
        enum GRPC_USE_ABSL = 1;
    }
    static if(!is(typeof(_STDC_PREDEF_H))) {
        enum _STDC_PREDEF_H = 1;
    }




    static if(!is(typeof(_STDINT_H))) {
        enum _STDINT_H = 1;
    }






    static if(!is(typeof(GRPC_CQ_VERSION_MINIMUM_FOR_CALLBACKABLE))) {
        enum GRPC_CQ_VERSION_MINIMUM_FOR_CALLBACKABLE = 2;
    }




    static if(!is(typeof(GRPC_CQ_CURRENT_VERSION))) {
        enum GRPC_CQ_CURRENT_VERSION = 2;
    }
    static if(!is(typeof(GRPC_ARG_CHANNEL_ID))) {
        enum GRPC_ARG_CHANNEL_ID = "grpc.channel_id";
    }




    static if(!is(typeof(GRPC_ARG_CHANNEL_POOL_DOMAIN))) {
        enum GRPC_ARG_CHANNEL_POOL_DOMAIN = "grpc.channel_pooling_domain";
    }




    static if(!is(typeof(GRPC_ARG_USE_LOCAL_SUBCHANNEL_POOL))) {
        enum GRPC_ARG_USE_LOCAL_SUBCHANNEL_POOL = "grpc.use_local_subchannel_pool";
    }




    static if(!is(typeof(GRPC_ARG_DNS_ARES_QUERY_TIMEOUT_MS))) {
        enum GRPC_ARG_DNS_ARES_QUERY_TIMEOUT_MS = "grpc.dns_ares_query_timeout";
    }




    static if(!is(typeof(GRPC_ARG_DNS_ENABLE_SRV_QUERIES))) {
        enum GRPC_ARG_DNS_ENABLE_SRV_QUERIES = "grpc.dns_enable_srv_queries";
    }




    static if(!is(typeof(GRPC_ARG_INHIBIT_HEALTH_CHECKING))) {
        enum GRPC_ARG_INHIBIT_HEALTH_CHECKING = "grpc.inhibit_health_checking";
    }




    static if(!is(typeof(GRPC_ARG_SURFACE_USER_AGENT))) {
        enum GRPC_ARG_SURFACE_USER_AGENT = "grpc.surface_user_agent";
    }




    static if(!is(typeof(GRPC_ARG_ENABLE_HTTP_PROXY))) {
        enum GRPC_ARG_ENABLE_HTTP_PROXY = "grpc.enable_http_proxy";
    }




    static if(!is(typeof(GRPC_ARG_DISABLE_CLIENT_AUTHORITY_FILTER))) {
        enum GRPC_ARG_DISABLE_CLIENT_AUTHORITY_FILTER = "grpc.disable_client_authority_filter";
    }




    static if(!is(typeof(GRPC_ARG_MOBILE_LOG_CONTEXT))) {
        enum GRPC_ARG_MOBILE_LOG_CONTEXT = "grpc.mobile_log_context";
    }




    static if(!is(typeof(GRPC_ARG_PER_RPC_RETRY_BUFFER_SIZE))) {
        enum GRPC_ARG_PER_RPC_RETRY_BUFFER_SIZE = "grpc.per_rpc_retry_buffer_size";
    }




    static if(!is(typeof(GRPC_ARG_ENABLE_RETRIES))) {
        enum GRPC_ARG_ENABLE_RETRIES = "grpc.enable_retries";
    }






    static if(!is(typeof(GRPC_ARG_OPTIMIZATION_TARGET))) {
        enum GRPC_ARG_OPTIMIZATION_TARGET = "grpc.optimization_target";
    }




    static if(!is(typeof(GRPC_ARG_WORKAROUND_CRONET_COMPRESSION))) {
        enum GRPC_ARG_WORKAROUND_CRONET_COMPRESSION = "grpc.workaround.cronet_compression";
    }




    static if(!is(typeof(GRPC_ARG_XDS_RESOURCE_DOES_NOT_EXIST_TIMEOUT_MS))) {
        enum GRPC_ARG_XDS_RESOURCE_DOES_NOT_EXIST_TIMEOUT_MS = "grpc.xds_resource_does_not_exist_timeout_ms";
    }




    static if(!is(typeof(GRPC_ARG_XDS_FAILOVER_TIMEOUT_MS))) {
        enum GRPC_ARG_XDS_FAILOVER_TIMEOUT_MS = "grpc.xds_failover_timeout_ms";
    }
    static if(!is(typeof(GRPC_ARG_LOCALITY_RETENTION_INTERVAL_MS))) {
        enum GRPC_ARG_LOCALITY_RETENTION_INTERVAL_MS = "grpc.xds_locality_retention_interval_ms";
    }
    static if(!is(typeof(GRPC_ARG_XDS_FALLBACK_TIMEOUT_MS))) {
        enum GRPC_ARG_XDS_FALLBACK_TIMEOUT_MS = "grpc.xds_fallback_timeout_ms";
    }
    static if(!is(typeof(GRPC_ARG_GRPCLB_FALLBACK_TIMEOUT_MS))) {
        enum GRPC_ARG_GRPCLB_FALLBACK_TIMEOUT_MS = "grpc.grpclb_fallback_timeout_ms";
    }
    static if(!is(typeof(GRPC_ARG_GRPCLB_CALL_TIMEOUT_MS))) {
        enum GRPC_ARG_GRPCLB_CALL_TIMEOUT_MS = "grpc.grpclb_call_timeout_ms";
    }
    static if(!is(typeof(GRPC_ARG_TCP_TX_ZEROCOPY_MAX_SIMULT_SENDS))) {
        enum GRPC_ARG_TCP_TX_ZEROCOPY_MAX_SIMULT_SENDS = "grpc.experimental.tcp_tx_zerocopy_max_simultaneous_sends";
    }
    static if(!is(typeof(GRPC_ARG_TCP_TX_ZEROCOPY_SEND_BYTES_THRESHOLD))) {
        enum GRPC_ARG_TCP_TX_ZEROCOPY_SEND_BYTES_THRESHOLD = "grpc.experimental.tcp_tx_zerocopy_send_bytes_threshold";
    }
    static if(!is(typeof(GRPC_ARG_TCP_TX_ZEROCOPY_ENABLED))) {
        enum GRPC_ARG_TCP_TX_ZEROCOPY_ENABLED = "grpc.experimental.tcp_tx_zerocopy_enabled";
    }
    static if(!is(typeof(GRPC_ARG_TCP_MAX_READ_CHUNK_SIZE))) {
        enum GRPC_ARG_TCP_MAX_READ_CHUNK_SIZE = "grpc.experimental.tcp_max_read_chunk_size";
    }






    static if(!is(typeof(GRPC_ARG_TCP_MIN_READ_CHUNK_SIZE))) {
        enum GRPC_ARG_TCP_MIN_READ_CHUNK_SIZE = "grpc.experimental.tcp_min_read_chunk_size";
    }
    static if(!is(typeof(GRPC_TCP_DEFAULT_READ_SLICE_SIZE))) {
        enum GRPC_TCP_DEFAULT_READ_SLICE_SIZE = 8192;
    }




    static if(!is(typeof(INT8_WIDTH))) {
        enum INT8_WIDTH = 8;
    }




    static if(!is(typeof(UINT8_WIDTH))) {
        enum UINT8_WIDTH = 8;
    }




    static if(!is(typeof(INT16_WIDTH))) {
        enum INT16_WIDTH = 16;
    }




    static if(!is(typeof(UINT16_WIDTH))) {
        enum UINT16_WIDTH = 16;
    }




    static if(!is(typeof(INT32_WIDTH))) {
        enum INT32_WIDTH = 32;
    }




    static if(!is(typeof(UINT32_WIDTH))) {
        enum UINT32_WIDTH = 32;
    }




    static if(!is(typeof(INT64_WIDTH))) {
        enum INT64_WIDTH = 64;
    }




    static if(!is(typeof(UINT64_WIDTH))) {
        enum UINT64_WIDTH = 64;
    }




    static if(!is(typeof(INT_LEAST8_WIDTH))) {
        enum INT_LEAST8_WIDTH = 8;
    }




    static if(!is(typeof(UINT_LEAST8_WIDTH))) {
        enum UINT_LEAST8_WIDTH = 8;
    }




    static if(!is(typeof(INT_LEAST16_WIDTH))) {
        enum INT_LEAST16_WIDTH = 16;
    }




    static if(!is(typeof(UINT_LEAST16_WIDTH))) {
        enum UINT_LEAST16_WIDTH = 16;
    }




    static if(!is(typeof(INT_LEAST32_WIDTH))) {
        enum INT_LEAST32_WIDTH = 32;
    }




    static if(!is(typeof(UINT_LEAST32_WIDTH))) {
        enum UINT_LEAST32_WIDTH = 32;
    }




    static if(!is(typeof(INT_LEAST64_WIDTH))) {
        enum INT_LEAST64_WIDTH = 64;
    }




    static if(!is(typeof(UINT_LEAST64_WIDTH))) {
        enum UINT_LEAST64_WIDTH = 64;
    }




    static if(!is(typeof(INT_FAST8_WIDTH))) {
        enum INT_FAST8_WIDTH = 8;
    }




    static if(!is(typeof(UINT_FAST8_WIDTH))) {
        enum UINT_FAST8_WIDTH = 8;
    }
    static if(!is(typeof(INT_FAST64_WIDTH))) {
        enum INT_FAST64_WIDTH = 64;
    }




    static if(!is(typeof(UINT_FAST64_WIDTH))) {
        enum UINT_FAST64_WIDTH = 64;
    }
    static if(!is(typeof(INTMAX_WIDTH))) {
        enum INTMAX_WIDTH = 64;
    }




    static if(!is(typeof(UINTMAX_WIDTH))) {
        enum UINTMAX_WIDTH = 64;
    }






    static if(!is(typeof(SIG_ATOMIC_WIDTH))) {
        enum SIG_ATOMIC_WIDTH = 32;
    }






    static if(!is(typeof(WCHAR_WIDTH))) {
        enum WCHAR_WIDTH = 32;
    }




    static if(!is(typeof(WINT_WIDTH))) {
        enum WINT_WIDTH = 32;
    }




    static if(!is(typeof(GRPC_ARG_TCP_READ_CHUNK_SIZE))) {
        enum GRPC_ARG_TCP_READ_CHUNK_SIZE = "grpc.experimental.tcp_read_chunk_size";
    }






    static if(!is(typeof(GRPC_ARG_USE_CRONET_PACKET_COALESCING))) {
        enum GRPC_ARG_USE_CRONET_PACKET_COALESCING = "grpc.use_cronet_packet_coalescing";
    }




    static if(!is(typeof(GRPC_ARG_ENABLE_CHANNELZ))) {
        enum GRPC_ARG_ENABLE_CHANNELZ = "grpc.enable_channelz";
    }




    static if(!is(typeof(_STDLIB_H))) {
        enum _STDLIB_H = 1;
    }




    static if(!is(typeof(GRPC_ARG_MAX_CHANNEL_TRACE_EVENT_MEMORY_PER_NODE))) {
        enum GRPC_ARG_MAX_CHANNEL_TRACE_EVENT_MEMORY_PER_NODE = "grpc.max_channel_trace_event_memory_per_node";
    }




    static if(!is(typeof(GRPC_ARG_SOCKET_FACTORY))) {
        enum GRPC_ARG_SOCKET_FACTORY = "grpc.socket_factory";
    }




    static if(!is(typeof(GRPC_ARG_SOCKET_MUTATOR))) {
        enum GRPC_ARG_SOCKET_MUTATOR = "grpc.socket_mutator";
    }




    static if(!is(typeof(GRPC_ARG_LB_POLICY_NAME))) {
        enum GRPC_ARG_LB_POLICY_NAME = "grpc.lb_policy_name";
    }
    static if(!is(typeof(GRPC_ARG_SERVICE_CONFIG_DISABLE_RESOLUTION))) {
        enum GRPC_ARG_SERVICE_CONFIG_DISABLE_RESOLUTION = "grpc.service_config_disable_resolution";
    }






    static if(!is(typeof(GRPC_ARG_SERVICE_CONFIG))) {
        enum GRPC_ARG_SERVICE_CONFIG = "grpc.service_config";
    }




    static if(!is(typeof(GRPC_ARG_EXPAND_WILDCARD_ADDRS))) {
        enum GRPC_ARG_EXPAND_WILDCARD_ADDRS = "grpc.expand_wildcard_addrs";
    }




    static if(!is(typeof(GRPC_ARG_RESOURCE_QUOTA))) {
        enum GRPC_ARG_RESOURCE_QUOTA = "grpc.resource_quota";
    }




    static if(!is(typeof(GRPC_ARG_ALLOW_REUSEPORT))) {
        enum GRPC_ARG_ALLOW_REUSEPORT = "grpc.so_reuseport";
    }




    static if(!is(typeof(GRPC_ARG_MAX_METADATA_SIZE))) {
        enum GRPC_ARG_MAX_METADATA_SIZE = "grpc.max_metadata_size";
    }




    static if(!is(typeof(__ldiv_t_defined))) {
        enum __ldiv_t_defined = 1;
    }




    static if(!is(typeof(GRPC_ARG_TSI_MAX_FRAME_SIZE))) {
        enum GRPC_ARG_TSI_MAX_FRAME_SIZE = "grpc.tsi.max_frame_size";
    }




    static if(!is(typeof(GRPC_SSL_SESSION_CACHE_ARG))) {
        enum GRPC_SSL_SESSION_CACHE_ARG = "grpc.ssl_session_cache";
    }




    static if(!is(typeof(GRPC_SSL_TARGET_NAME_OVERRIDE_ARG))) {
        enum GRPC_SSL_TARGET_NAME_OVERRIDE_ARG = "grpc.ssl_target_name_override";
    }




    static if(!is(typeof(__lldiv_t_defined))) {
        enum __lldiv_t_defined = 1;
    }




    static if(!is(typeof(RAND_MAX))) {
        enum RAND_MAX = 2147483647;
    }




    static if(!is(typeof(EXIT_FAILURE))) {
        enum EXIT_FAILURE = 1;
    }




    static if(!is(typeof(EXIT_SUCCESS))) {
        enum EXIT_SUCCESS = 0;
    }






    static if(!is(typeof(GRPC_ARG_SERVER_HANDSHAKE_TIMEOUT_MS))) {
        enum GRPC_ARG_SERVER_HANDSHAKE_TIMEOUT_MS = "grpc.server_handshake_timeout_ms";
    }




    static if(!is(typeof(GRPC_ARG_DNS_MIN_TIME_BETWEEN_RESOLUTIONS_MS))) {
        enum GRPC_ARG_DNS_MIN_TIME_BETWEEN_RESOLUTIONS_MS = "grpc.dns_min_time_between_resolutions_ms";
    }




    static if(!is(typeof(GRPC_ARG_INITIAL_RECONNECT_BACKOFF_MS))) {
        enum GRPC_ARG_INITIAL_RECONNECT_BACKOFF_MS = "grpc.initial_reconnect_backoff_ms";
    }




    static if(!is(typeof(GRPC_ARG_MAX_RECONNECT_BACKOFF_MS))) {
        enum GRPC_ARG_MAX_RECONNECT_BACKOFF_MS = "grpc.max_reconnect_backoff_ms";
    }




    static if(!is(typeof(GRPC_ARG_MIN_RECONNECT_BACKOFF_MS))) {
        enum GRPC_ARG_MIN_RECONNECT_BACKOFF_MS = "grpc.min_reconnect_backoff_ms";
    }




    static if(!is(typeof(GRPC_ARG_SECONDARY_USER_AGENT_STRING))) {
        enum GRPC_ARG_SECONDARY_USER_AGENT_STRING = "grpc.secondary_user_agent";
    }




    static if(!is(typeof(GRPC_ARG_PRIMARY_USER_AGENT_STRING))) {
        enum GRPC_ARG_PRIMARY_USER_AGENT_STRING = "grpc.primary_user_agent";
    }




    static if(!is(typeof(GRPC_ARG_DEFAULT_AUTHORITY))) {
        enum GRPC_ARG_DEFAULT_AUTHORITY = "grpc.default_authority";
    }




    static if(!is(typeof(GRPC_ARG_KEEPALIVE_PERMIT_WITHOUT_CALLS))) {
        enum GRPC_ARG_KEEPALIVE_PERMIT_WITHOUT_CALLS = "grpc.keepalive_permit_without_calls";
    }




    static if(!is(typeof(GRPC_ARG_KEEPALIVE_TIMEOUT_MS))) {
        enum GRPC_ARG_KEEPALIVE_TIMEOUT_MS = "grpc.keepalive_timeout_ms";
    }




    static if(!is(typeof(GRPC_ARG_KEEPALIVE_TIME_MS))) {
        enum GRPC_ARG_KEEPALIVE_TIME_MS = "grpc.keepalive_time_ms";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_ENABLE_TRUE_BINARY))) {
        enum GRPC_ARG_HTTP2_ENABLE_TRUE_BINARY = "grpc.http2.true_binary";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_WRITE_BUFFER_SIZE))) {
        enum GRPC_ARG_HTTP2_WRITE_BUFFER_SIZE = "grpc.http2.write_buffer_size";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_MAX_PING_STRIKES))) {
        enum GRPC_ARG_HTTP2_MAX_PING_STRIKES = "grpc.http2.max_ping_strikes";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_MAX_PINGS_WITHOUT_DATA))) {
        enum GRPC_ARG_HTTP2_MAX_PINGS_WITHOUT_DATA = "grpc.http2.max_pings_without_data";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_SCHEME))) {
        enum GRPC_ARG_HTTP2_SCHEME = "grpc.http2_scheme";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_MIN_RECV_PING_INTERVAL_WITHOUT_DATA_MS))) {
        enum GRPC_ARG_HTTP2_MIN_RECV_PING_INTERVAL_WITHOUT_DATA_MS = "grpc.http2.min_ping_interval_without_data_ms";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_MIN_SENT_PING_INTERVAL_WITHOUT_DATA_MS))) {
        enum GRPC_ARG_HTTP2_MIN_SENT_PING_INTERVAL_WITHOUT_DATA_MS = "grpc.http2.min_time_between_pings_ms";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_BDP_PROBE))) {
        enum GRPC_ARG_HTTP2_BDP_PROBE = "grpc.http2.bdp_probe";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_MAX_FRAME_SIZE))) {
        enum GRPC_ARG_HTTP2_MAX_FRAME_SIZE = "grpc.http2.max_frame_size";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_HPACK_TABLE_SIZE_ENCODER))) {
        enum GRPC_ARG_HTTP2_HPACK_TABLE_SIZE_ENCODER = "grpc.http2.hpack_table_size.encoder";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_HPACK_TABLE_SIZE_DECODER))) {
        enum GRPC_ARG_HTTP2_HPACK_TABLE_SIZE_DECODER = "grpc.http2.hpack_table_size.decoder";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_STREAM_LOOKAHEAD_BYTES))) {
        enum GRPC_ARG_HTTP2_STREAM_LOOKAHEAD_BYTES = "grpc.http2.lookahead_bytes";
    }




    static if(!is(typeof(GRPC_ARG_HTTP2_INITIAL_SEQUENCE_NUMBER))) {
        enum GRPC_ARG_HTTP2_INITIAL_SEQUENCE_NUMBER = "grpc.http2.initial_sequence_number";
    }




    static if(!is(typeof(GRPC_ARG_ENABLE_DEADLINE_CHECKS))) {
        enum GRPC_ARG_ENABLE_DEADLINE_CHECKS = "grpc.enable_deadline_checking";
    }




    static if(!is(typeof(GRPC_ARG_ENABLE_PER_MESSAGE_COMPRESSION))) {
        enum GRPC_ARG_ENABLE_PER_MESSAGE_COMPRESSION = "grpc.per_message_compression";
    }




    static if(!is(typeof(GRPC_ARG_CLIENT_IDLE_TIMEOUT_MS))) {
        enum GRPC_ARG_CLIENT_IDLE_TIMEOUT_MS = "grpc.client_idle_timeout_ms";
    }




    static if(!is(typeof(GRPC_ARG_MAX_CONNECTION_AGE_GRACE_MS))) {
        enum GRPC_ARG_MAX_CONNECTION_AGE_GRACE_MS = "grpc.max_connection_age_grace_ms";
    }




    static if(!is(typeof(GRPC_ARG_MAX_CONNECTION_AGE_MS))) {
        enum GRPC_ARG_MAX_CONNECTION_AGE_MS = "grpc.max_connection_age_ms";
    }




    static if(!is(typeof(GRPC_ARG_MAX_CONNECTION_IDLE_MS))) {
        enum GRPC_ARG_MAX_CONNECTION_IDLE_MS = "grpc.max_connection_idle_ms";
    }




    static if(!is(typeof(GRPC_ARG_MAX_SEND_MESSAGE_LENGTH))) {
        enum GRPC_ARG_MAX_SEND_MESSAGE_LENGTH = "grpc.max_send_message_length";
    }






    static if(!is(typeof(GRPC_ARG_MAX_RECEIVE_MESSAGE_LENGTH))) {
        enum GRPC_ARG_MAX_RECEIVE_MESSAGE_LENGTH = "grpc.max_receive_message_length";
    }




    static if(!is(typeof(GRPC_ARG_MAX_CONCURRENT_STREAMS))) {
        enum GRPC_ARG_MAX_CONCURRENT_STREAMS = "grpc.max_concurrent_streams";
    }




    static if(!is(typeof(GRPC_ARG_MINIMAL_STACK))) {
        enum GRPC_ARG_MINIMAL_STACK = "grpc.minimal_stack";
    }




    static if(!is(typeof(GRPC_ARG_ENABLE_LOAD_REPORTING))) {
        enum GRPC_ARG_ENABLE_LOAD_REPORTING = "grpc.loadreporting";
    }




    static if(!is(typeof(GRPC_ARG_ENABLE_CENSUS))) {
        enum GRPC_ARG_ENABLE_CENSUS = "grpc.census";
    }
    static if(!is(typeof(GRPC_ALLOW_GPR_SLICE_FUNCTIONS))) {
        enum GRPC_ALLOW_GPR_SLICE_FUNCTIONS = 1;
    }
    static if(!is(typeof(GRPC_COMPRESSION_CHANNEL_ENABLED_ALGORITHMS_BITSET))) {
        enum GRPC_COMPRESSION_CHANNEL_ENABLED_ALGORITHMS_BITSET = "grpc.compression_enabled_algorithms_bitset";
    }




    static if(!is(typeof(GRPC_COMPRESSION_CHANNEL_DEFAULT_LEVEL))) {
        enum GRPC_COMPRESSION_CHANNEL_DEFAULT_LEVEL = "grpc.default_compression_level";
    }




    static if(!is(typeof(GRPC_COMPRESSION_CHANNEL_DEFAULT_ALGORITHM))) {
        enum GRPC_COMPRESSION_CHANNEL_DEFAULT_ALGORITHM = "grpc.default_compression_algorithm";
    }




    static if(!is(typeof(GRPC_COMPRESSION_REQUEST_ALGORITHM_MD_KEY))) {
        enum GRPC_COMPRESSION_REQUEST_ALGORITHM_MD_KEY = "grpc-internal-encoding-request";
    }
    static if(!is(typeof(GRPC_GOOGLE_CREDENTIALS_ENV_VAR))) {
        enum GRPC_GOOGLE_CREDENTIALS_ENV_VAR = "GOOGLE_APPLICATION_CREDENTIALS";
    }




    static if(!is(typeof(GRPC_DEFAULT_SSL_ROOTS_FILE_PATH_ENV_VAR))) {
        enum GRPC_DEFAULT_SSL_ROOTS_FILE_PATH_ENV_VAR = "GRPC_DEFAULT_SSL_ROOTS_FILE_PATH";
    }




    static if(!is(typeof(GRPC_TRANSPORT_SECURITY_LEVEL_PROPERTY_NAME))) {
        enum GRPC_TRANSPORT_SECURITY_LEVEL_PROPERTY_NAME = "security_level";
    }




    static if(!is(typeof(GRPC_SSL_SESSION_REUSED_PROPERTY))) {
        enum GRPC_SSL_SESSION_REUSED_PROPERTY = "ssl_session_reused";
    }




    static if(!is(typeof(GRPC_X509_PEM_CERT_CHAIN_PROPERTY_NAME))) {
        enum GRPC_X509_PEM_CERT_CHAIN_PROPERTY_NAME = "x509_pem_cert_chain";
    }




    static if(!is(typeof(GRPC_X509_PEM_CERT_PROPERTY_NAME))) {
        enum GRPC_X509_PEM_CERT_PROPERTY_NAME = "x509_pem_cert";
    }




    static if(!is(typeof(GRPC_X509_SAN_PROPERTY_NAME))) {
        enum GRPC_X509_SAN_PROPERTY_NAME = "x509_subject_alternative_name";
    }




    static if(!is(typeof(GRPC_X509_CN_PROPERTY_NAME))) {
        enum GRPC_X509_CN_PROPERTY_NAME = "x509_common_name";
    }




    static if(!is(typeof(GRPC_SSL_TRANSPORT_SECURITY_TYPE))) {
        enum GRPC_SSL_TRANSPORT_SECURITY_TYPE = "ssl";
    }




    static if(!is(typeof(GRPC_TRANSPORT_SECURITY_TYPE_PROPERTY_NAME))) {
        enum GRPC_TRANSPORT_SECURITY_TYPE_PROPERTY_NAME = "transport_security_type";
    }






    static if(!is(typeof(GRPC_METADATA_CREDENTIALS_PLUGIN_SYNC_MAX))) {
        enum GRPC_METADATA_CREDENTIALS_PLUGIN_SYNC_MAX = 4;
    }






    static if(!is(typeof(GRPC_MAX_COMPLETION_QUEUE_PLUCKERS))) {
        enum GRPC_MAX_COMPLETION_QUEUE_PLUCKERS = 6;
    }
    static if(!is(typeof(__GLIBC_MINOR__))) {
        enum __GLIBC_MINOR__ = 31;
    }




    static if(!is(typeof(__GLIBC__))) {
        enum __GLIBC__ = 2;
    }




    static if(!is(typeof(__GNU_LIBRARY__))) {
        enum __GNU_LIBRARY__ = 6;
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_SCANF))) {
        enum __GLIBC_USE_DEPRECATED_SCANF = 0;
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_GETS))) {
        enum __GLIBC_USE_DEPRECATED_GETS = 0;
    }




    static if(!is(typeof(__USE_FORTIFY_LEVEL))) {
        enum __USE_FORTIFY_LEVEL = 0;
    }




    static if(!is(typeof(__USE_GNU))) {
        enum __USE_GNU = 1;
    }




    static if(!is(typeof(__USE_ATFILE))) {
        enum __USE_ATFILE = 1;
    }




    static if(!is(typeof(__USE_MISC))) {
        enum __USE_MISC = 1;
    }




    static if(!is(typeof(__USE_LARGEFILE64))) {
        enum __USE_LARGEFILE64 = 1;
    }




    static if(!is(typeof(__USE_LARGEFILE))) {
        enum __USE_LARGEFILE = 1;
    }




    static if(!is(typeof(__USE_ISOC99))) {
        enum __USE_ISOC99 = 1;
    }




    static if(!is(typeof(__USE_ISOC95))) {
        enum __USE_ISOC95 = 1;
    }




    static if(!is(typeof(__USE_XOPEN2KXSI))) {
        enum __USE_XOPEN2KXSI = 1;
    }




    static if(!is(typeof(__USE_XOPEN2K))) {
        enum __USE_XOPEN2K = 1;
    }




    static if(!is(typeof(__USE_XOPEN2K8XSI))) {
        enum __USE_XOPEN2K8XSI = 1;
    }




    static if(!is(typeof(__USE_XOPEN2K8))) {
        enum __USE_XOPEN2K8 = 1;
    }




    static if(!is(typeof(_LARGEFILE_SOURCE))) {
        enum _LARGEFILE_SOURCE = 1;
    }




    static if(!is(typeof(__USE_UNIX98))) {
        enum __USE_UNIX98 = 1;
    }




    static if(!is(typeof(__USE_XOPEN_EXTENDED))) {
        enum __USE_XOPEN_EXTENDED = 1;
    }




    static if(!is(typeof(__USE_XOPEN))) {
        enum __USE_XOPEN = 1;
    }




    static if(!is(typeof(_ATFILE_SOURCE))) {
        enum _ATFILE_SOURCE = 1;
    }




    static if(!is(typeof(__USE_POSIX199506))) {
        enum __USE_POSIX199506 = 1;
    }




    static if(!is(typeof(__USE_POSIX199309))) {
        enum __USE_POSIX199309 = 1;
    }




    static if(!is(typeof(__USE_POSIX2))) {
        enum __USE_POSIX2 = 1;
    }




    static if(!is(typeof(__USE_POSIX))) {
        enum __USE_POSIX = 1;
    }




    static if(!is(typeof(_POSIX_C_SOURCE))) {
        enum _POSIX_C_SOURCE = 200809L;
    }




    static if(!is(typeof(_POSIX_SOURCE))) {
        enum _POSIX_SOURCE = 1;
    }




    static if(!is(typeof(__USE_ISOC11))) {
        enum __USE_ISOC11 = 1;
    }




    static if(!is(typeof(__GLIBC_USE_ISOC2X))) {
        enum __GLIBC_USE_ISOC2X = 1;
    }




    static if(!is(typeof(_LARGEFILE64_SOURCE))) {
        enum _LARGEFILE64_SOURCE = 1;
    }




    static if(!is(typeof(_XOPEN_SOURCE_EXTENDED))) {
        enum _XOPEN_SOURCE_EXTENDED = 1;
    }




    static if(!is(typeof(_XOPEN_SOURCE))) {
        enum _XOPEN_SOURCE = 700;
    }




    static if(!is(typeof(_ISOC2X_SOURCE))) {
        enum _ISOC2X_SOURCE = 1;
    }




    static if(!is(typeof(_ISOC11_SOURCE))) {
        enum _ISOC11_SOURCE = 1;
    }




    static if(!is(typeof(_ISOC99_SOURCE))) {
        enum _ISOC99_SOURCE = 1;
    }




    static if(!is(typeof(_ISOC95_SOURCE))) {
        enum _ISOC95_SOURCE = 1;
    }
    static if(!is(typeof(_FEATURES_H))) {
        enum _FEATURES_H = 1;
    }
    static if(!is(typeof(_ENDIAN_H))) {
        enum _ENDIAN_H = 1;
    }




    static if(!is(typeof(__SYSCALL_WORDSIZE))) {
        enum __SYSCALL_WORDSIZE = 64;
    }




    static if(!is(typeof(__WORDSIZE_TIME64_COMPAT32))) {
        enum __WORDSIZE_TIME64_COMPAT32 = 1;
    }




    static if(!is(typeof(__WORDSIZE))) {
        enum __WORDSIZE = 64;
    }
    static if(!is(typeof(_BITS_WCHAR_H))) {
        enum _BITS_WCHAR_H = 1;
    }




    static if(!is(typeof(__WCOREFLAG))) {
        enum __WCOREFLAG = 0x80;
    }




    static if(!is(typeof(__W_CONTINUED))) {
        enum __W_CONTINUED = 0xffff;
    }
    static if(!is(typeof(__WCLONE))) {
        enum __WCLONE = 0x80000000;
    }




    static if(!is(typeof(__WALL))) {
        enum __WALL = 0x40000000;
    }




    static if(!is(typeof(__WNOTHREAD))) {
        enum __WNOTHREAD = 0x20000000;
    }




    static if(!is(typeof(WNOWAIT))) {
        enum WNOWAIT = 0x01000000;
    }




    static if(!is(typeof(WCONTINUED))) {
        enum WCONTINUED = 8;
    }




    static if(!is(typeof(WEXITED))) {
        enum WEXITED = 4;
    }




    static if(!is(typeof(WSTOPPED))) {
        enum WSTOPPED = 2;
    }




    static if(!is(typeof(WUNTRACED))) {
        enum WUNTRACED = 2;
    }




    static if(!is(typeof(WNOHANG))) {
        enum WNOHANG = 1;
    }




    static if(!is(typeof(_BITS_UINTN_IDENTITY_H))) {
        enum _BITS_UINTN_IDENTITY_H = 1;
    }




    static if(!is(typeof(__FD_SETSIZE))) {
        enum __FD_SETSIZE = 1024;
    }




    static if(!is(typeof(__STATFS_MATCHES_STATFS64))) {
        enum __STATFS_MATCHES_STATFS64 = 1;
    }




    static if(!is(typeof(__RLIM_T_MATCHES_RLIM64_T))) {
        enum __RLIM_T_MATCHES_RLIM64_T = 1;
    }




    static if(!is(typeof(__INO_T_MATCHES_INO64_T))) {
        enum __INO_T_MATCHES_INO64_T = 1;
    }




    static if(!is(typeof(__OFF_T_MATCHES_OFF64_T))) {
        enum __OFF_T_MATCHES_OFF64_T = 1;
    }
    static if(!is(typeof(_BITS_TYPESIZES_H))) {
        enum _BITS_TYPESIZES_H = 1;
    }




    static if(!is(typeof(__timer_t_defined))) {
        enum __timer_t_defined = 1;
    }




    static if(!is(typeof(__time_t_defined))) {
        enum __time_t_defined = 1;
    }




    static if(!is(typeof(__struct_tm_defined))) {
        enum __struct_tm_defined = 1;
    }




    static if(!is(typeof(__timeval_defined))) {
        enum __timeval_defined = 1;
    }




    static if(!is(typeof(_STRUCT_TIMESPEC))) {
        enum _STRUCT_TIMESPEC = 1;
    }




    static if(!is(typeof(_BITS_TYPES_STRUCT_SCHED_PARAM))) {
        enum _BITS_TYPES_STRUCT_SCHED_PARAM = 1;
    }




    static if(!is(typeof(__itimerspec_defined))) {
        enum __itimerspec_defined = 1;
    }




    static if(!is(typeof(__sigset_t_defined))) {
        enum __sigset_t_defined = 1;
    }




    static if(!is(typeof(_BITS_TYPES_LOCALE_T_H))) {
        enum _BITS_TYPES_LOCALE_T_H = 1;
    }




    static if(!is(typeof(__clockid_t_defined))) {
        enum __clockid_t_defined = 1;
    }




    static if(!is(typeof(__clock_t_defined))) {
        enum __clock_t_defined = 1;
    }
    static if(!is(typeof(_BITS_TYPES___LOCALE_T_H))) {
        enum _BITS_TYPES___LOCALE_T_H = 1;
    }
    static if(!is(typeof(_BITS_TYPES_H))) {
        enum _BITS_TYPES_H = 1;
    }






    static if(!is(typeof(STA_CLK))) {
        enum STA_CLK = 0x8000;
    }




    static if(!is(typeof(STA_MODE))) {
        enum STA_MODE = 0x4000;
    }




    static if(!is(typeof(STA_NANO))) {
        enum STA_NANO = 0x2000;
    }




    static if(!is(typeof(STA_CLOCKERR))) {
        enum STA_CLOCKERR = 0x1000;
    }




    static if(!is(typeof(STA_PPSERROR))) {
        enum STA_PPSERROR = 0x0800;
    }




    static if(!is(typeof(STA_PPSWANDER))) {
        enum STA_PPSWANDER = 0x0400;
    }




    static if(!is(typeof(STA_PPSJITTER))) {
        enum STA_PPSJITTER = 0x0200;
    }




    static if(!is(typeof(STA_PPSSIGNAL))) {
        enum STA_PPSSIGNAL = 0x0100;
    }




    static if(!is(typeof(STA_FREQHOLD))) {
        enum STA_FREQHOLD = 0x0080;
    }




    static if(!is(typeof(STA_UNSYNC))) {
        enum STA_UNSYNC = 0x0040;
    }




    static if(!is(typeof(STA_DEL))) {
        enum STA_DEL = 0x0020;
    }




    static if(!is(typeof(STA_INS))) {
        enum STA_INS = 0x0010;
    }




    static if(!is(typeof(STA_FLL))) {
        enum STA_FLL = 0x0008;
    }




    static if(!is(typeof(STA_PPSTIME))) {
        enum STA_PPSTIME = 0x0004;
    }




    static if(!is(typeof(STA_PPSFREQ))) {
        enum STA_PPSFREQ = 0x0002;
    }




    static if(!is(typeof(STA_PLL))) {
        enum STA_PLL = 0x0001;
    }
    static if(!is(typeof(ADJ_OFFSET_SS_READ))) {
        enum ADJ_OFFSET_SS_READ = 0xa001;
    }




    static if(!is(typeof(ADJ_OFFSET_SINGLESHOT))) {
        enum ADJ_OFFSET_SINGLESHOT = 0x8001;
    }




    static if(!is(typeof(ADJ_TICK))) {
        enum ADJ_TICK = 0x4000;
    }




    static if(!is(typeof(ADJ_NANO))) {
        enum ADJ_NANO = 0x2000;
    }




    static if(!is(typeof(ADJ_MICRO))) {
        enum ADJ_MICRO = 0x1000;
    }




    static if(!is(typeof(ADJ_SETOFFSET))) {
        enum ADJ_SETOFFSET = 0x0100;
    }




    static if(!is(typeof(ADJ_TAI))) {
        enum ADJ_TAI = 0x0080;
    }




    static if(!is(typeof(ADJ_TIMECONST))) {
        enum ADJ_TIMECONST = 0x0020;
    }




    static if(!is(typeof(ADJ_STATUS))) {
        enum ADJ_STATUS = 0x0010;
    }




    static if(!is(typeof(ADJ_ESTERROR))) {
        enum ADJ_ESTERROR = 0x0008;
    }




    static if(!is(typeof(ADJ_MAXERROR))) {
        enum ADJ_MAXERROR = 0x0004;
    }




    static if(!is(typeof(ADJ_FREQUENCY))) {
        enum ADJ_FREQUENCY = 0x0002;
    }




    static if(!is(typeof(ADJ_OFFSET))) {
        enum ADJ_OFFSET = 0x0001;
    }




    static if(!is(typeof(_BITS_TIMEX_H))) {
        enum _BITS_TIMEX_H = 1;
    }
    static if(!is(typeof(_BITS_TIME64_H))) {
        enum _BITS_TIME64_H = 1;
    }




    static if(!is(typeof(TIMER_ABSTIME))) {
        enum TIMER_ABSTIME = 1;
    }




    static if(!is(typeof(CLOCK_TAI))) {
        enum CLOCK_TAI = 11;
    }




    static if(!is(typeof(CLOCK_BOOTTIME_ALARM))) {
        enum CLOCK_BOOTTIME_ALARM = 9;
    }




    static if(!is(typeof(CLOCK_REALTIME_ALARM))) {
        enum CLOCK_REALTIME_ALARM = 8;
    }




    static if(!is(typeof(CLOCK_BOOTTIME))) {
        enum CLOCK_BOOTTIME = 7;
    }




    static if(!is(typeof(CLOCK_MONOTONIC_COARSE))) {
        enum CLOCK_MONOTONIC_COARSE = 6;
    }




    static if(!is(typeof(CLOCK_REALTIME_COARSE))) {
        enum CLOCK_REALTIME_COARSE = 5;
    }




    static if(!is(typeof(CLOCK_MONOTONIC_RAW))) {
        enum CLOCK_MONOTONIC_RAW = 4;
    }




    static if(!is(typeof(CLOCK_THREAD_CPUTIME_ID))) {
        enum CLOCK_THREAD_CPUTIME_ID = 3;
    }




    static if(!is(typeof(CLOCK_PROCESS_CPUTIME_ID))) {
        enum CLOCK_PROCESS_CPUTIME_ID = 2;
    }




    static if(!is(typeof(CLOCK_MONOTONIC))) {
        enum CLOCK_MONOTONIC = 1;
    }




    static if(!is(typeof(CLOCK_REALTIME))) {
        enum CLOCK_REALTIME = 0;
    }






    static if(!is(typeof(_BITS_TIME_H))) {
        enum _BITS_TIME_H = 1;
    }




    static if(!is(typeof(_THREAD_SHARED_TYPES_H))) {
        enum _THREAD_SHARED_TYPES_H = 1;
    }
    static if(!is(typeof(__PTHREAD_MUTEX_HAVE_PREV))) {
        enum __PTHREAD_MUTEX_HAVE_PREV = 1;
    }




    static if(!is(typeof(_THREAD_MUTEX_INTERNAL_H))) {
        enum _THREAD_MUTEX_INTERNAL_H = 1;
    }




    static if(!is(typeof(_BITS_STDINT_UINTN_H))) {
        enum _BITS_STDINT_UINTN_H = 1;
    }




    static if(!is(typeof(_BITS_STDINT_INTN_H))) {
        enum _BITS_STDINT_INTN_H = 1;
    }




    static if(!is(typeof(_BITS_SETJMP_H))) {
        enum _BITS_SETJMP_H = 1;
    }
    static if(!is(typeof(__FD_ZERO_STOS))) {
        enum __FD_ZERO_STOS = "stosq";
    }




    static if(!is(typeof(CLONE_IO))) {
        enum CLONE_IO = 0x80000000;
    }




    static if(!is(typeof(CLONE_NEWNET))) {
        enum CLONE_NEWNET = 0x40000000;
    }




    static if(!is(typeof(CLONE_NEWPID))) {
        enum CLONE_NEWPID = 0x20000000;
    }




    static if(!is(typeof(CLONE_NEWUSER))) {
        enum CLONE_NEWUSER = 0x10000000;
    }




    static if(!is(typeof(CLONE_NEWIPC))) {
        enum CLONE_NEWIPC = 0x08000000;
    }




    static if(!is(typeof(CLONE_NEWUTS))) {
        enum CLONE_NEWUTS = 0x04000000;
    }




    static if(!is(typeof(CLONE_NEWCGROUP))) {
        enum CLONE_NEWCGROUP = 0x02000000;
    }




    static if(!is(typeof(CLONE_CHILD_SETTID))) {
        enum CLONE_CHILD_SETTID = 0x01000000;
    }




    static if(!is(typeof(CLONE_UNTRACED))) {
        enum CLONE_UNTRACED = 0x00800000;
    }




    static if(!is(typeof(CLONE_DETACHED))) {
        enum CLONE_DETACHED = 0x00400000;
    }




    static if(!is(typeof(CLONE_CHILD_CLEARTID))) {
        enum CLONE_CHILD_CLEARTID = 0x00200000;
    }




    static if(!is(typeof(CLONE_PARENT_SETTID))) {
        enum CLONE_PARENT_SETTID = 0x00100000;
    }




    static if(!is(typeof(CLONE_SETTLS))) {
        enum CLONE_SETTLS = 0x00080000;
    }




    static if(!is(typeof(CLONE_SYSVSEM))) {
        enum CLONE_SYSVSEM = 0x00040000;
    }




    static if(!is(typeof(CLONE_NEWNS))) {
        enum CLONE_NEWNS = 0x00020000;
    }






    static if(!is(typeof(CLONE_THREAD))) {
        enum CLONE_THREAD = 0x00010000;
    }




    static if(!is(typeof(CLONE_PARENT))) {
        enum CLONE_PARENT = 0x00008000;
    }




    static if(!is(typeof(CLONE_VFORK))) {
        enum CLONE_VFORK = 0x00004000;
    }




    static if(!is(typeof(CLONE_PTRACE))) {
        enum CLONE_PTRACE = 0x00002000;
    }




    static if(!is(typeof(CLONE_PIDFD))) {
        enum CLONE_PIDFD = 0x00001000;
    }




    static if(!is(typeof(CLONE_SIGHAND))) {
        enum CLONE_SIGHAND = 0x00000800;
    }




    static if(!is(typeof(CLONE_FILES))) {
        enum CLONE_FILES = 0x00000400;
    }




    static if(!is(typeof(CLONE_FS))) {
        enum CLONE_FS = 0x00000200;
    }




    static if(!is(typeof(CLONE_VM))) {
        enum CLONE_VM = 0x00000100;
    }




    static if(!is(typeof(CSIGNAL))) {
        enum CSIGNAL = 0x000000ff;
    }




    static if(!is(typeof(SCHED_RESET_ON_FORK))) {
        enum SCHED_RESET_ON_FORK = 0x40000000;
    }




    static if(!is(typeof(SCHED_DEADLINE))) {
        enum SCHED_DEADLINE = 6;
    }




    static if(!is(typeof(SCHED_IDLE))) {
        enum SCHED_IDLE = 5;
    }




    static if(!is(typeof(SCHED_ISO))) {
        enum SCHED_ISO = 4;
    }




    static if(!is(typeof(SCHED_BATCH))) {
        enum SCHED_BATCH = 3;
    }




    static if(!is(typeof(SCHED_RR))) {
        enum SCHED_RR = 2;
    }




    static if(!is(typeof(SCHED_FIFO))) {
        enum SCHED_FIFO = 1;
    }




    static if(!is(typeof(SCHED_OTHER))) {
        enum SCHED_OTHER = 0;
    }




    static if(!is(typeof(_BITS_SCHED_H))) {
        enum _BITS_SCHED_H = 1;
    }




    static if(!is(typeof(__have_pthread_attr_t))) {
        enum __have_pthread_attr_t = 1;
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_COMMON_H))) {
        enum _BITS_PTHREADTYPES_COMMON_H = 1;
    }
    static if(!is(typeof(__SIZEOF_PTHREAD_BARRIERATTR_T))) {
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_RWLOCKATTR_T))) {
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_CONDATTR_T))) {
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_COND_T))) {
        enum __SIZEOF_PTHREAD_COND_T = 48;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_MUTEXATTR_T))) {
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_BARRIER_T))) {
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_RWLOCK_T))) {
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_ATTR_T))) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_MUTEX_T))) {
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_ARCH_H))) {
        enum _BITS_PTHREADTYPES_ARCH_H = 1;
    }




    static if(!is(typeof(__LONG_DOUBLE_USES_FLOAT128))) {
        enum __LONG_DOUBLE_USES_FLOAT128 = 0;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_TYPES_EXT))) {
        enum __GLIBC_USE_IEC_60559_TYPES_EXT = 1;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT_C2X))) {
        enum __GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = 1;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT))) {
        enum __GLIBC_USE_IEC_60559_FUNCS_EXT = 1;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT_C2X))) {
        enum __GLIBC_USE_IEC_60559_BFP_EXT_C2X = 1;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT))) {
        enum __GLIBC_USE_IEC_60559_BFP_EXT = 1;
    }




    static if(!is(typeof(__GLIBC_USE_LIB_EXT2))) {
        enum __GLIBC_USE_LIB_EXT2 = 1;
    }




    static if(!is(typeof(__HAVE_FLOAT64X_LONG_DOUBLE))) {
        enum __HAVE_FLOAT64X_LONG_DOUBLE = 1;
    }




    static if(!is(typeof(__HAVE_FLOAT64X))) {
        enum __HAVE_FLOAT64X = 1;
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT128))) {
        enum __HAVE_DISTINCT_FLOAT128 = 0;
    }




    static if(!is(typeof(__HAVE_FLOAT128))) {
        enum __HAVE_FLOAT128 = 0;
    }
    static if(!is(typeof(__HAVE_FLOATN_NOT_TYPEDEF))) {
        enum __HAVE_FLOATN_NOT_TYPEDEF = 0;
    }
    static if(!is(typeof(__HAVE_DISTINCT_FLOAT64X))) {
        enum __HAVE_DISTINCT_FLOAT64X = 0;
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT32X))) {
        enum __HAVE_DISTINCT_FLOAT32X = 0;
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT64))) {
        enum __HAVE_DISTINCT_FLOAT64 = 0;
    }




    static if(!is(typeof(__HAVE_DISTINCT_FLOAT32))) {
        enum __HAVE_DISTINCT_FLOAT32 = 0;
    }






    static if(!is(typeof(__HAVE_FLOAT128X))) {
        enum __HAVE_FLOAT128X = 0;
    }




    static if(!is(typeof(__HAVE_FLOAT32X))) {
        enum __HAVE_FLOAT32X = 1;
    }




    static if(!is(typeof(__HAVE_FLOAT64))) {
        enum __HAVE_FLOAT64 = 1;
    }




    static if(!is(typeof(__HAVE_FLOAT32))) {
        enum __HAVE_FLOAT32 = 1;
    }




    static if(!is(typeof(__HAVE_FLOAT16))) {
        enum __HAVE_FLOAT16 = 0;
    }
    static if(!is(typeof(_BITS_ENDIANNESS_H))) {
        enum _BITS_ENDIANNESS_H = 1;
    }
    static if(!is(typeof(__PDP_ENDIAN))) {
        enum __PDP_ENDIAN = 3412;
    }




    static if(!is(typeof(__BIG_ENDIAN))) {
        enum __BIG_ENDIAN = 4321;
    }




    static if(!is(typeof(__LITTLE_ENDIAN))) {
        enum __LITTLE_ENDIAN = 1234;
    }




    static if(!is(typeof(_BITS_ENDIAN_H))) {
        enum _BITS_ENDIAN_H = 1;
    }
    static if(!is(typeof(__CPU_SETSIZE))) {
        enum __CPU_SETSIZE = 1024;
    }




    static if(!is(typeof(_BITS_CPU_SET_H))) {
        enum _BITS_CPU_SET_H = 1;
    }
    static if(!is(typeof(_BITS_BYTESWAP_H))) {
        enum _BITS_BYTESWAP_H = 1;
    }






    static if(!is(typeof(_ALLOCA_H))) {
        enum _ALLOCA_H = 1;
    }




    static if(!is(typeof(_SYS_CDEFS_H))) {
        enum _SYS_CDEFS_H = 1;
    }
    static if(!is(typeof(__glibc_c99_flexarr_available))) {
        enum __glibc_c99_flexarr_available = 1;
    }
    static if(!is(typeof(__HAVE_GENERIC_SELECTION))) {
        enum __HAVE_GENERIC_SELECTION = 1;
    }




    static if(!is(typeof(_SYS_SELECT_H))) {
        enum _SYS_SELECT_H = 1;
    }
    static if(!is(typeof(_SYS_TYPES_H))) {
        enum _SYS_TYPES_H = 1;
    }
    static if(!is(typeof(__BIT_TYPES_DEFINED__))) {
        enum __BIT_TYPES_DEFINED__ = 1;
    }
    static if(!is(typeof(_TIME_H))) {
        enum _TIME_H = 1;
    }




    static if(!is(typeof(TIME_UTC))) {
        enum TIME_UTC = 1;
    }
    static if(!is(typeof(__GNUC_VA_LIST))) {
        enum __GNUC_VA_LIST = 1;
    }
}
