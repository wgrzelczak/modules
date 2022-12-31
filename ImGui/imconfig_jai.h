#pragma once

extern "C" void handle_c_assert(bool condition, char* msg);

#define IM_ASSERT(_EXPR) handle_c_assert(_EXPR, #_EXPR)
