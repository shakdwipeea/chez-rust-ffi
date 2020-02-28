use libc::c_char;
use libc::size_t;
use std::ffi::CStr;
use std::ffi::CString;
use std::iter;
use std::slice;

#[no_mangle]
pub extern "C" fn addition(a: u32, b: u32) -> u32 {
    a + b
}

#[no_mangle]
pub extern "C" fn count_characters(s: *const c_char) -> u32 {
    let c_str = unsafe {
        assert!(!s.is_null());

        CStr::from_ptr(s)
    };

    let r_str = c_str.to_str().unwrap();
    r_str.chars().count() as u32
}

// String returns

// Here we use a pair of methods into_raw and from_raw.
// These convert a CString into a raw pointer that may be passed across the FFI boundary.
// Ownership of the string is transferred to the caller, but the caller must return the string
// to Rust in order to properly deallocate the memory.

#[no_mangle]
pub extern "C" fn theme_song_generate(length: u8) -> *mut c_char {
    let mut song = String::from("💣 ");
    song.extend(iter::repeat("na ").take(length as usize));
    song.push_str("Batman! 💣");

    let c_str_song = CString::new(song).unwrap();
    c_str_song.into_raw()
}

#[no_mangle]
pub extern "C" fn theme_song_free(s: *mut c_char) {
    unsafe {
        if s.is_null() {
            return;
        }
        CString::from_raw(s)
    };
}

// Slice arguments

#[no_mangle]
pub extern "C" fn sum_of_even(n: *const u32, len: size_t) -> u32 {
    let numbers = unsafe {
        assert!(!n.is_null());

        slice::from_raw_parts(n, len as usize)
    };

    numbers.iter().filter(|&v| v % 2 == 0).sum()
}
