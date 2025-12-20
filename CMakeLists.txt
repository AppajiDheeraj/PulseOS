cmake_minimum_required(VERSION 3.16)

project(CarbonQt VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appCarbonQt
    main.cpp
)

qt_add_qml_module(appCarbonQt
    URI CarbonQt
    VERSION 1.0
    QML_FILES
        qml/App.qml
        qml/window/MainWindow.qml
        QML_FILES
)

target_link_libraries(appCarbonQt
    PRIVATE Qt6::Quick
)

set_target_properties(appCarbonQt PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)
