# CMake generated Testfile for 
# Source directory: /home/user/colopy/viceroy_cpp
# Build directory: /home/user/colopy/viceroy_cpp/build-win
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(sim_tests "/home/user/colopy/viceroy_cpp/build-win/sim_tests.exe")
set_tests_properties(sim_tests PROPERTIES  _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;166;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
add_test(drydock_tests "/home/user/colopy/viceroy_cpp/build-win/drydock_tests.exe")
set_tests_properties(drydock_tests PROPERTIES  WORKING_DIRECTORY "/home/user/colopy/viceroy_cpp/.." _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;172;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
add_test(drydockc_gate "/home/user/colopy/viceroy_cpp/build-win/drydockc.exe" "data" "-o" "/home/user/colopy/viceroy_cpp/build-win/game.pack")
set_tests_properties(drydockc_gate PROPERTIES  WORKING_DIRECTORY "/home/user/colopy/viceroy_cpp/.." _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;176;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
add_test(forge_map "/home/user/colopy/viceroy_cpp/build-win/Forge.exe" "map" "selftest")
set_tests_properties(forge_map PROPERTIES  _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;184;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
add_test(forge_rules "/home/user/colopy/viceroy_cpp/build-win/Forge.exe" "rules" "selftest")
set_tests_properties(forge_rules PROPERTIES  _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;185;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
add_test(forge_mod "/home/user/colopy/viceroy_cpp/build-win/Forge.exe" "mod" "selftest")
set_tests_properties(forge_mod PROPERTIES  _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;186;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
add_test(forge_save "/home/user/colopy/viceroy_cpp/build-win/Forge.exe" "save" "selftest")
set_tests_properties(forge_save PROPERTIES  _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;187;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
add_test(forge_data "/home/user/colopy/viceroy_cpp/build-win/Forge.exe" "data" "selftest")
set_tests_properties(forge_data PROPERTIES  _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;188;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
add_test(forge_engine "/home/user/colopy/viceroy_cpp/build-win/Forge.exe" "engine" "selftest")
set_tests_properties(forge_engine PROPERTIES  WORKING_DIRECTORY "/home/user/colopy/viceroy_cpp/.." _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;191;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
add_test(forge_bundle "/home/user/colopy/viceroy_cpp/build-win/Forge.exe" "bundle" "selftest")
set_tests_properties(forge_bundle PROPERTIES  WORKING_DIRECTORY "/home/user/colopy/viceroy_cpp/.." _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;195;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
add_test(validate_schema "/usr/local/bin/python3" "tools/validate_schema.py")
set_tests_properties(validate_schema PROPERTIES  WORKING_DIRECTORY "/home/user/colopy/viceroy_cpp/.." _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;217;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
add_test(validate_all "/usr/local/bin/python3" "tools/validate_all.py")
set_tests_properties(validate_all PROPERTIES  WORKING_DIRECTORY "/home/user/colopy/viceroy_cpp/.." _BACKTRACE_TRIPLES "/home/user/colopy/viceroy_cpp/CMakeLists.txt;219;add_test;/home/user/colopy/viceroy_cpp/CMakeLists.txt;0;")
