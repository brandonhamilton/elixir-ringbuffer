#include <stdlib.h>
#include "erl_nif.h"

typedef struct {
  ERL_NIF_TERM* buffer;
  size_t size;
  int head;
  int tail;
  ERL_NIF_TERM default_term;
} ringbuffer_t;

typedef struct {
  ErlNifEnv* environment;
} ringbuffer_priv_t;

ErlNifResourceType* RES_TYPE;

void destroy_resource(ErlNifEnv* env, void* res) {
  enif_free(((ringbuffer_t*) res)->buffer);
}

static int open_resource(ErlNifEnv* env) {
  const char* mod = "Elixir.RingBuffer.Internals";
  const char* name = "Buffer";
  int flags = ERL_NIF_RT_CREATE | ERL_NIF_RT_TAKEOVER;
  RES_TYPE = enif_open_resource_type(env, mod, name, destroy_resource, flags, NULL);
  if (RES_TYPE == NULL) {
    return -1;
  }
  return 0;
}

static int load(ErlNifEnv* env, void** priv, ERL_NIF_TERM load_info) {
  if (open_resource(env) == -1) {
    return -1;
  }
  ringbuffer_priv_t* data = enif_alloc(sizeof(ringbuffer_priv_t));
  if (data == NULL) {
    return -1;
  }
  data->environment = enif_alloc_env();
  *priv = (void*) data;
  return 0;
}

static int reload(ErlNifEnv* env, void** priv, ERL_NIF_TERM load_info) {
  if (open_resource(env) == -1) {
    return -1;
  }
  return 0;
}

static int upgrade(ErlNifEnv* env, void** new, void** old, ERL_NIF_TERM info) {
  if (open_resource(env) == -1) {
    return -1;
  }
  return 0;
}

static void unload(ErlNifEnv* env, void* priv) {
  enif_free_env(((ringbuffer_priv_t*) priv)->environment);
  enif_free(priv);
}

ERL_NIF_TERM ringbuffer_new(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  ringbuffer_t *buffer_res;
  ringbuffer_priv_t* buffer_env;
  ERL_NIF_TERM buffer_term;
  unsigned int capacity;
  unsigned int index;

  if (argc != 2) {
    return enif_make_badarg(env);
  }
  buffer_env = (ringbuffer_priv_t*) enif_priv_data(env);

  enif_get_uint(env, argv[0], &capacity);
  
  buffer_res = enif_alloc_resource(RES_TYPE, sizeof(ringbuffer_t));
  buffer_res->default_term = enif_make_copy(buffer_env->environment, argv[1]);
  buffer_res->size = capacity;
  buffer_res->buffer = enif_alloc(capacity * sizeof(ERL_NIF_TERM));
  for (index = 0; index < capacity; index++) {
    buffer_res->buffer[index] = buffer_res->default_term;
  }
  buffer_res->head = buffer_res->tail = 0;

  buffer_term = enif_make_resource(env, buffer_res);
  enif_release_resource(buffer_res);
  return buffer_term;
}

ERL_NIF_TERM ringbuffer_get(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  ringbuffer_t *buffer_res;
  ringbuffer_priv_t* buffer_env;
  unsigned int position;

  if (argc != 2) {
    return enif_make_badarg(env);
  }

  if (!enif_get_resource(env, argv[0], RES_TYPE, (void**) &buffer_res)) {
    return enif_make_badarg(env);
  }

  buffer_env = (ringbuffer_priv_t*) enif_priv_data(env);

  enif_get_uint(env, argv[1], &position);

  ERL_NIF_TERM result = buffer_res->buffer[(buffer_res->head + position) % buffer_res->size];
  return result;
}

ERL_NIF_TERM ringbuffer_set(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  ringbuffer_t* buffer_res;
  ringbuffer_priv_t* buffer_env;
  unsigned int position;

  if (argc != 3) {
    return enif_make_badarg(env);
  }

  if (!enif_get_resource(env, argv[0], RES_TYPE, (void**) &buffer_res)) {
    return enif_make_badarg(env);
  }

  buffer_env = (ringbuffer_priv_t*) enif_priv_data(env);

  enif_get_uint(env, argv[1], &position);
  ERL_NIF_TERM item = enif_make_copy(buffer_env->environment, argv[2]);
  buffer_res->buffer[(buffer_res->head + position) % buffer_res->size] = item;

  return argv[0];
}

ERL_NIF_TERM ringbuffer_reset(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  ringbuffer_t* buffer_res;
  unsigned int position;

  if (argc != 2) {
    return enif_make_badarg(env);
  }

  if (!enif_get_resource(env, argv[0], RES_TYPE, (void**) &buffer_res)) {
    return enif_make_badarg(env);
  }

  enif_get_uint(env, argv[1], &position);

  buffer_res->buffer[(buffer_res->head + position) % buffer_res->size] = buffer_res->default_term;

  return argv[0];
}

ERL_NIF_TERM ringbuffer_clear(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  ringbuffer_t* buffer_res;
  unsigned int index;

  if (argc != 1) {
    return enif_make_badarg(env);
  }

  if (!enif_get_resource(env, argv[0], RES_TYPE, (void**) &buffer_res)) {
    return enif_make_badarg(env);
  }

  for (index = 0; index < buffer_res->size; index++) {
    buffer_res->buffer[index] = buffer_res->default_term;
  }

  buffer_res->head = buffer_res->tail = 0;

  return argv[0];
}

ERL_NIF_TERM ringbuffer_to_list(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  ringbuffer_t *buffer_res;

  if (argc != 1) {
    return enif_make_badarg(env);
  }

  if (!enif_get_resource(env, argv[0], RES_TYPE, (void**) &buffer_res)) {
    return enif_make_badarg(env);
  }

  return enif_make_list_from_array(env, &buffer_res->buffer[buffer_res->head], buffer_res->size );
}

ERL_NIF_TERM ringbuffer_from_list(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  ringbuffer_t *buffer_res;
  ringbuffer_priv_t* buffer_env;
  ERL_NIF_TERM list, head, tail;
  ERL_NIF_TERM buffer_term;
  unsigned int capacity;
  unsigned int index;

  if (argc != 2) {
    return enif_make_badarg(env);
  }

  list = argv[0];
  if (!enif_is_list(env, list)) {
    return enif_make_badarg(env);
  }

  if (!enif_get_list_length(env, argv[0], &capacity)) {
    return enif_make_badarg(env);
  }

  buffer_env = (ringbuffer_priv_t*) enif_priv_data(env);

  buffer_res = enif_alloc_resource(RES_TYPE, sizeof(ringbuffer_t));
  buffer_res->default_term = enif_make_copy(buffer_env->environment, argv[1]);
  buffer_res->size = capacity;
  buffer_res->buffer = enif_alloc(capacity * sizeof(ERL_NIF_TERM));

  index = 0;
  while(enif_get_list_cell(env, list, &head, &tail)) {
    buffer_res->buffer[index++] = head;
    list = tail;
  }
  buffer_res->head = buffer_res->tail = 0;

  buffer_term = enif_make_resource(env, buffer_res);
  enif_release_resource(buffer_res);
  return buffer_term;
}

ERL_NIF_TERM nif_loaded(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  return enif_make_atom(env, "true");
}

/*
 * Expose functions
 */
static ErlNifFunc nif_funcs[] = {
  { "new", 2, ringbuffer_new, 0 },
  { "get", 2, ringbuffer_get, 0 },
  { "set", 3, ringbuffer_set, 0 },
  { "reset", 2, ringbuffer_reset, 0 },
  { "clear", 1, ringbuffer_clear, 0 },
  { "to_list", 1, ringbuffer_to_list, 0 },
  { "from_list", 2, ringbuffer_from_list, 0 },
  { "nif_loaded?", 0, nif_loaded, 0 }
};

ERL_NIF_INIT(Elixir.RingBuffer.Internals, nif_funcs, &load, &reload, &upgrade, &unload)
