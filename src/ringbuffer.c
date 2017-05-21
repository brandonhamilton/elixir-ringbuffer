#include <stdlib.h>
#include "erl_nif.h"

ERL_NIF_TERM nif_loaded(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  return enif_make_atom(env, "true");
}

int upgrade(ErlNifEnv* env, void** new, void** old, ERL_NIF_TERM info){
  return 0;
}

/*
 * Expose functions
 */
static ErlNifFunc nif_funcs[] = {
  { "nif_loaded?", 0, nif_loaded, 0 }
};

ERL_NIF_INIT(Elixir.RingBuffer, nif_funcs, NULL, NULL, upgrade, NULL)
