cmake_minimum_required(VERSION 3.16)

project(CarbonQt VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

# Disable FluentUI demo/example in PROD
set(FLUENTUI_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(FLUENTUI_BUILD_DEMO OFF CACHE BOOL "" FORCE)

add_subdirectory(third_party/FluentUI)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appCarbonQt
    main.cpp
    resources.qrc
)

qt_add_qml_module(appCarbonQt
    URI CarbonQt
    VERSION 1.0
    QML_FILES
        qml/App.qml
        qml/window/MainWindow.qml
        qml/global/GlobalModel.qml
        qml/global/ItemsOriginal.qml
        qml/global/ItemsFooter.qml
        qml/pages/Home.qml
        qml/pages/Processes.qml
        qml/components/ExitDialog.qml
        qml/window/AboutDialog.qml
    RESOURCES
        qml/global/qmldir
        resources.qrc
    SOURCES
        backend/core/system_info.h
        backend/core/system_info.cpp
        backend/BackendManager.h
        backend/BackendManager.cpp
        backend/utils/proc_reader.h
        backend/utils/proc_reader.cpp
        backend/core/cpu_stat.cpp
        backend/core/cpu_stat.h
        backend/core/memory_stat.h
        backend/core/memory_stat.cpp
        backend/core/process_model.h
        backend/core/process_model.cpp
        backend/SystemController.h
        backend/SystemController.cpp
)

target_link_libraries(appCarbonQt
    PRIVATE
        Qt6::Quick
)

set_target_properties(appCarbonQt PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)
