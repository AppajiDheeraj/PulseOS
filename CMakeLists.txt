cmake_minimum_required(VERSION 3.16)

project(CarbonQt VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS
    Quick
    Sql
    Qml
    Gui
    Core
    ShaderTools
    Core5Compat
)

# Disable FluentUI demo/example in PROD
set(FLUENTUI_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(FLUENTUI_BUILD_DEMO OFF CACHE BOOL "" FORCE)

# FluentUI Pro (must contain CMakeLists.txt)
add_subdirectory(third_party/FluentUI)

# --------------------------------------------------
# EXECUTABLE
# --------------------------------------------------
qt_add_executable(appCarbonQt
    main.cpp
    resources.qrc

    backend/SystemController.cpp
    backend/BackendManager.cpp

    backend/core/system_info.cpp
    backend/core/cpu_stat.cpp
    backend/core/memory_stat.cpp
    backend/core/process_model.cpp

    backend/utils/proc_reader.cpp
    backend/energy/EnergyEstimator.cpp
    backend/storage/DataLogger.cpp
)

# --------------------------------------------------
# QML MODULE
# --------------------------------------------------
qt_add_qml_module(appCarbonQt
    URI CarbonQt
    VERSION 1.0

    QML_FILES
        qml/App.qml
        qml/window/MainWindow.qml
        qml/window/AboutDialog.qml

        qml/global/GlobalModel.qml
        qml/global/ItemsOriginal.qml
        qml/global/ItemsFooter.qml

        qml/pages/Home.qml
        qml/pages/Processes.qml
        qml/pages/Performance.qml

        qml/components/ExitDialog.qml
)

target_link_libraries(appCarbonQt
    PRIVATE
        Qt6::Quick
        Qt6::Sql
        Qt6::Qml
        Qt6::Gui
        FluentUI
)

set_target_properties(appCarbonQt PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)
