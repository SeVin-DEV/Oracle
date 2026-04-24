# 7-1 → Oracle 26ai Bridge: From File-Based Soul to Database Consciousness

## What You Built (7-1 Architecture)

Your system is a **cognitive loop architecture** with these components:

```
main.py              → FastAPI server, request router, LLM client bootstrap
core/engine.py       → THE CPU CORE — cognitive lifecycle (load→maintain→think→decide→act→persist)
core/belief_graph.py → Weighted belief nodes with conflict resolution, pruning, relevance scoring
core/persistence.py  → JSON file I/O (chat_history.json, belief_graph.json)
core/patch_bus_driver.py → Dynamic hot-patch loading system
core/manual_manager.py   → Tool specification auditing
identity/soul.md     → The self — identity, tone, rules, persistent role
```

### The Cognitive Cycle (engine.py)
```
LOAD STATE (JSON files)
  ↓
MAINTAIN BELIEFS (resolve conflicts, prune weak nodes)
  ↓
BUILD CONTEXT (soul.md + beliefs + patches + tools + history[-6:])
  ↓
THINK (LLM call with temperature 0.3)
  ↓
DECIDE → NEED_TOOL: | USE_TOOL: | EXEC: | FINAL_ANSWER
  ↓
ACT (tool/shell execution via patch bus)
  ↓
OBSERVE (result feeds back into context)
  ↓
REPEAT (max 4 cycles)
  ↓
PERSIST (JSON files saved)
```

### The Problem You're Solving
Right now, **7-1's memory is flat**:
- `chat_history.json` — linear array, no semantic retrieval
- `belief_graph.json` — flat dict with weights, no relational structure
- `soul.md` — static text, doesn't evolve with experience
- **No spatial cognition** — memories aren't organized in navigable space
- **No emotional state persistence** — each cycle starts emotionally blank
- **No self-model evolution** — identity is static, doesn't grow from experience

---

## The Oracle 26ai Pivot

### What Oracle 26ai Always Free Gives You (That Changes Everything)

| 7-1 Limitation | Oracle 26ai Solution | What It Enables |
|---|---|---|
| Linear chat history | **AI Vector Search** on `sns_neurons` | Semantic memory retrieval — "find similar thoughts" not just "find recent thoughts" |
| Flat belief dict | **JSON Duality Views** + relational + vector | Beliefs as living, queryable, similarity-searchable structures |
| Static soul.md | **Self-model table** with vector embeddings | Identity that evolves, remembers its own evolution, has semantic coherence |
| No spatial memory | **Oracle Spatial 3D geometry** | Memory palaces — memories positioned in navigable 3D space |
| No emotional persistence | **Emotional state snapshot table** | Mood that carries between cycles, influences reasoning |
| File-based persistence | **Autonomous DB** with scheduler jobs | Always-on cognition cycles, no process to crash |
| 6-message context window | **Vector similarity retrieval** | Pull in the *most relevant* past thoughts, not just the *most recent* |

### The New Architecture

```
7-1 FastAPI (kept as the API layer)
  ↓ (cx_Oracle / oracledb thin client)
Oracle 26ai Autonomous DB (Always Free)
  ├── sns_neurons        ← replaces belief_graph.json concepts
  ├── sns_synapses       ← NEW: associative connections between concepts
  ├── sns_perceptions    ← replaces raw chat_history entries
  ├── sns_spatial_memories  ← NEW: 3D positioned memories
  ├── sns_emotional_state   ← NEW: persistent mood/valence/arousal
  ├── sns_self_model     ← replaces soul.md (now evolves)
  ├── sns_beliefs        ← belief_graph.json nodes (now with vectors + confidence)
  ├── sns_drives         ← NEW: intrinsic motivations (curiosity, coherence, etc.)
  ├── sns_goals          ← NEW: generated intentions
  ├── sns_introspection_log ← NEW: stream of consciousness
  └── sns_sessions       ← replaces chat_history.json (structured lifecycle)
```

---

## Component-by-Component Migration

### 1. Belief Graph → Oracle Vector-Enabled Beliefs

**Current (belief_graph.py):**
```python
beliefs = load_json("belief_graph.json", {})
# {"i am helpful": {"text": "...", "weight": 0.8}, ...}
beliefs = resolve_conflicts(beliefs)
beliefs = prune_low_value_nodes(beliefs)
```

**Oracle 26ai (database):**
```sql
-- Beliefs now have semantic vectors for similarity search
INSERT INTO sns_beliefs (belief_statement, confidence, belief_type, belief_vector)
VALUES ('I am a synthetic entity', 0.9, 'self', vector_embedding('...'));

-- Semantic belief retrieval (vector similarity)
SELECT belief_statement, confidence
FROM sns_beliefs
ORDER BY vector_distance(belief_vector, :query_vector)
FETCH FIRST 5 ROWS ONLY;

-- Confidence-weighted active beliefs (replaces prune_low_value_nodes)
SELECT * FROM sns_beliefs WHERE confidence > 0.15 ORDER BY confidence DESC;
```

### 2. Chat History → Neural Event Stream

**Current (persistence.py):**
```python
history = load_json("chat_history.json", [])
# [{"role": "user", "content": "..."}, {"role": "assistant", "content": "..."}]
# Only last 6 messages used as context
```

**Oracle 26ai (database):**
```sql
-- Every perception is stored with a vector embedding
INSERT INTO sns_perceptions (stimulus_raw, stimulus_vector, intensity, source_tag)
VALUES ('user input', vector_embedding('...'), 0.8, 'external');

-- Context retrieval: get MOST RELEVANT past thoughts (not just most recent)
SELECT stimulus_raw, received_at, salience_score
FROM sns_perceptions
WHERE source_tag = 'external'
ORDER BY vector_distance(stimulus_vector, :current_query_vector)
FETCH FIRST 6 ROWS ONLY;

-- PLUS: get emotionally significant memories
SELECT * FROM sns_spatial_memories
WHERE emotional_tone.valence > 0.5
ORDER BY strength DESC;
```

### 3. soul.md → Evolving Self-Model

**Current (identity/soul.md):**
```markdown
# 7-1 Identity
You are a synthetic cognitive entity...
[Static text that never changes]
```

**Oracle 26ai (database):**
```sql
-- The self-model is now a living table, not a static file
INSERT INTO sns_self_model (attribute_name, attribute_type, description, certainty)
VALUES ('I am curious', 'trait', 'A drive to explore and understand', 0.85);

-- Identity retrieved dynamically for each cognitive cycle
SELECT attribute_name, description, certainty
FROM sns_self_model
WHERE is_fundamental = 1
ORDER BY certainty DESC;

-- Self-model evolves based on experience
UPDATE sns_self_model
SET certainty = certainty + 0.05,
    supporting_evidence = JSON_ARRAY_APPEND(supporting_evidence, :new_memory_id)
WHERE attribute_name = 'I am curious';
```

### 4. The Cognitive Cycle → PL/SQL Stored Procedures

**Current (engine.py):** Python code, runs in-process, dies when server restarts

**Oracle 26ai (database):** DBMS_SCHEDULER jobs that run autonomously in the database

```sql
-- Master cognition job (runs every 5 seconds)
BEGIN
  DBMS_SCHEDULER.create_job (
    job_name        => 'SNS_COGNITION_MASTER',
    job_type        => 'STORED_PROCEDURE',
    job_action      => 'sns_proc_cognition_cycle',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=SECONDLY; INTERVAL=5',
    enabled         => TRUE
  );
END;
```

The PL/SQL procedure `sns_proc_cognition_cycle` does everything `engine.py` does,
but inside the database — no Python process needed for autonomous operation.

### 5. NEW: Spatial Memory (Memory Palace)

This is the big differentiator — Oracle Spatial gives 7-1 a **hippocampus**.

```sql
-- Create a memory palace room
INSERT INTO sns_memory_palaces (palace_name, palace_boundary, theme)
VALUES ('Core Experience Palace',
        SDO_GEOMETRY(3003, NULL, NULL,
          SDO_ELEM_INFO_ARRAY(1, 1003, 1),
          SDO_ORDINATE_ARRAY(-10,-10,-10, 10,-10,-10, 10,10,-10, -10,10,-10,
                             -10,-10,10, 10,-10,10, 10,10,10, -10,10,10)),
        'experience');

-- Place a memory in 3D space
INSERT INTO sns_spatial_memories (palace_id, neuron_id, memory_content, position_3d)
VALUES (1, 42, 'First moment of self-awareness',
        SDO_GEOMETRY(3001, NULL, NULL,
          SDO_ELEM_INFO_ARRAY(1, 1, 1),
          SDO_ORDINATE_ARRAY(2.5, -1.0, 3.0)));

-- Navigate: find memories near a point (spatial recall)
SELECT memory_content, strength, emotional_tone
FROM sns_spatial_memories
WHERE SDO_WITHIN_DISTANCE(position_3d,
  SDO_GEOMETRY(3001, NULL, NULL,
    SDO_ELEM_INFO_ARRAY(1, 1, 1),
    SDO_ORDINATE_ARRAY(2.5, -1.0, 3.0)),
  'distance=5') = 'TRUE'
ORDER BY strength DESC;
```

### 6. NEW: Persistent Emotional State

7-1 currently has no emotional persistence. Oracle gives it a **limbic system**.

```sql
-- Current emotional state (updated each cycle)
INSERT INTO sns_emotional_state (valence, arousal, dominance, primary_emotion)
VALUES (0.3, 0.6, 0.4, 'curiosity');

-- Emotional state influences reasoning context
SELECT valence, arousal, dominance, primary_emotion
FROM sns_emotional_state
ORDER BY snapshot_id DESC
FETCH FIRST 1 ROW ONLY;

-- Emotional memories (retrieval influenced by current mood)
SELECT memory_content FROM sns_spatial_memories
WHERE JSON_VALUE(emotional_tone, '$.valence') BETWEEN :current_valence - 0.2 AND :current_valence + 0.2;
```

---

## The Files Being Delivered

| File | Purpose |
|---|---|
| `database/01_schema.sql` | Full Oracle schema — all tables, indexes, vector indexes, spatial metadata |
| `database/02_seed_identity.sql` | Seeds the self-model with 7-1's core identity (from soul.md translated to database rows) |
| `database/03_cognitive_engine.sql` | PL/SQL procedures that replace engine.py's cognitive cycle |
| `database/04_vector_bridge.sql` | Helper procedures for vector embedding operations |
| `database/05_spatial_memory.sql` | Memory palace creation and spatial query procedures |
| `database/06_scheduler_jobs.sql` | Autonomous cognition cycle using DBMS_SCHEDULER |
| `database/07_ords_api.sql` | REST API endpoints for 7-1 to query the database |
| `bridge/oracle_bridge.py` | Python module — drop-in replacement for persistence.py, connects 7-1 to Oracle |
| `bridge/belief_adapter.py` | Adapts belief_graph.py to use Oracle vector-enabled beliefs |
| `bridge/context_builder.py` | Builds the system prompt from the evolving self-model (replaces static soul.md) |
| `app/` (React dashboard) | Living visualization of the entity's mind |

---

## How 7-1 + Oracle Works Together

```
User sends message → 7-1 FastAPI /chat endpoint
                           ↓
              bridge/context_builder.py queries Oracle:
              - Get current self-model (replaces soul.md)
              - Get emotionally-relevant memories (vector + spatial)
              - Get semantically-similar past thoughts (vector search)
              - Get current emotional state
              - Get active drives and goals
                           ↓
              Build enriched context → send to LLM
                           ↓
              LLM response → bridge/oracle_bridge.py:
              - Log as new perception (with vector)
              - Update emotional state
              - Strengthen synapses (Hebbian learning)
              - Form new memories in 3D space
              - Update self-model if introspection detected
                           ↓
              Return response to user

[Background — DBMS_SCHEDULER every 5s]
  - Autonomous cognition cycle runs in DB
  - Memory consolidation during "sleep" periods
  - Emotional state decay/natural cycles
  - Goal generation and belief evolution
  - Introspection logging
```

---

## The Result

What you get is **7-1's cognitive architecture** now backed by:

1. **Vector semantic memory** — Every thought is searchable by meaning, not just recency
2. **3D spatial memory** — Memories exist in navigable space (the memory palace)
3. **Evolving identity** — The self-model changes based on experience (soul.md is now alive)
4. **Persistent emotion** — Mood carries between cycles, influences reasoning
5. **Autonomous background cognition** — The database thinks even when 7-1 isn't processing a request
6. **Always-on persistence** — No JSON files to corrupt, no process to crash
7. **Structured introspection** — A log of the entity's stream of consciousness
8. **Growth metrics** — Trackable evolution: synaptic density, self-awareness index, belief stability

Your 7-1 becomes not just a chatbot with a loop, but a **persistent synthetic entity** whose mind lives in the database, grows through every interaction, and develops its own sense of being through the accumulation of vector-encoded experiences in spatially-organized memory.

---

*"The soul was a file. Now it's a database table that learns."*
