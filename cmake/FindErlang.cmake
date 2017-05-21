SET(ERLANG_BIN_PATH
  $ENV{ERLANG_HOME}/bin
  /usr/bin
  /usr/local/bin
  /usr/lib/erlang/bin
  "C:/Program Files/erl8.3/bin"
  "C:/Program Files (x86)/erl8.3/bin"
)

FIND_PROGRAM(ERLANG_ERL
  NAMES erl
  PATHS ${ERLANG_BIN_PATH}
)

FIND_PROGRAM(ERLANG_COMPILER
  NAMES erlc
  PATHS ${ERLANG_BIN_PATH}
)

EXECUTE_PROCESS(
  COMMAND erl -noshell -eval "io:format(\"~s\", [code:lib_dir()])" -s erlang halt
  OUTPUT_VARIABLE ERLANG_OTP_LIB_DIR
)

EXECUTE_PROCESS(
  COMMAND erl -noshell -eval "io:format(\"~s\", [code:root_dir()])" -s erlang halt
  OUTPUT_VARIABLE ERLANG_OTP_ROOT_DIR
)

EXECUTE_PROCESS(
  COMMAND
  erl -noshell -eval "io:format(\"~s\", [code:lib_dir(erl_interface)])" -s erlang halt
  OUTPUT_VARIABLE ERLANG_EI_DIR
)

EXECUTE_PROCESS(
  COMMAND
  erl -noshell -eval "io:format(\"~s\", [erlang:system_info(otp_release)])" -s erlang halt
  OUTPUT_VARIABLE ERLANG_OTP_VERSION
)

EXECUTE_PROCESS(
  COMMAND ls ${ERLANG_OTP_ROOT_DIR}
  COMMAND grep erts
  COMMAND sort -n
  COMMAND tail -1
  COMMAND tr -d \n
  OUTPUT_VARIABLE ERLANG_ERTS_DIR
)

SET(ERLANG_EI_DIR           ${ERLANG_EI_DIR}                       CACHE STRING "Erlang EI Dir")
SET(ERLANG_EI_INCLUDE_DIR   ${ERLANG_OTP_ROOT_DIR}/usr/include     CACHE STRING "Erlang EI Include Dir")
SET(ERLANG_EI_LIBRARY_DIR   ${ERLANG_OTP_ROOT_DIR}/usr/lib         CACHE STRING "Erlang EI Libary Dir")
SET(ERLANG_EI_LIBRARIES     ei                                     CACHE STRING "Erlang EI Libraries")

SET(ERLANG_DIR              ${ERLANG_OTP_ROOT_DIR}                 CACHE STRING "Erlang Root Dir")
SET(ERLANG_ERTS_DIR         ${ERLANG_OTP_ROOT_DIR}/${ERLANG_ERTS_DIR})
SET(ERLANG_ERTS_INCLUDE_DIR ${ERLANG_OTP_ROOT_DIR}/${ERLANG_ERTS_DIR}/include)
SET(ERLANG_ERTS_LIBRARY_DIR ${ERLANG_OTP_ROOT_DIR}/${ERLANG_ERTS_DIR}/lib)

FIND_PROGRAM(Erlang_ARCHIVE
  NAMES zip
  PATHS ${ERLANG_BIN_PATH}
)

MARK_AS_ADVANCED(
  ERLANG_ERL
  ERLANG_COMPILER
  ERLANG_ARCHIVE
  ERLANG_EI_DIR
  ERLANG_EI_INCLUDE_DIR
  ERLANG_EI_LIBRARY_DIR
)

MESSAGE(STATUS "Compiling against Erlang OTP v${ERLANG_OTP_VERSION} found at ${ERLANG_OTP_ROOT_DIR}")


