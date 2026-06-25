# Idea Scoring

Use this reference in `idea-pool` and when rescuing a generic premise.

## Candidate Format

Generate 20 candidates. Each candidate must include:

- **Grade** (S/A/B/C, 标注平台合规等级)
- Title.
- Hook.
- Synopsis.
- Protagonist starting wound.
- Cheat or core abnormality.
- Anti-template twist.
- Chaos rule.
- First-chapter explosion.
- Serial engine.
- Drop-off risk.
- Scores.

## Score Rubric

Use 1-10 scores:

- Click potential: would the title and hook make a reader open it?
- Novelty: is the core abnormality more than a familiar template rename?
- Chaos ceiling: can the premise become stranger over time without collapsing?
- Serialization stability: can it support 80-120 chapters?
- Commercial potential: are there repeatable payoffs, enemies, resources, and map turns?
- Platform risk: lower score means safer; higher score means more likely to cross content or originality boundaries.

After scoring, recommend the top 3. Do not automatically choose for the user.

## Grade Distribution Rule

When generating a batch of 20 candidates, the grade spread **must not cluster in a single tier**.

**Minimum coverage**: at least 3 distinct grade levels must be represented (S/A/B/C).
**Maximum clustering**: no single grade may exceed 60% of the batch (i.e. ≤12 out of 20).
**Label each candidate** with its grade in the output, using the `**Grade**:` field.

If the user already has an existing batch on file (e.g. from an earlier `idea-pool` run), and calls `idea-pool` again for more options, check which grades are missing or underrepresented, and weight the new batch toward those gaps.

See `references/platform-compliance-2026.md` for the full grade definitions (S/A/B/C tier + prohibited topics).

## Anti-Template Tests

Before recommending a premise, ask:

- Is the protagonist's motive more specific than "我要变强"?
- Is the cheat more specific than "系统给奖励"?
- Is the opening conflict visible in chapter 1?
- Does the world have a strange rule readers can remember?
- Could this be mistaken for ten other cultivation books if names were removed?

If the answer to the last question is yes, mutate one of:

- The cultivation logic.
- The protagonist's misread.
- The cost of power.
- The antagonist obsession.
- The social institution around the protagonist.

## Useful Anti-Template Twists

- The protagonist is not untalented; the test itself is afraid of measuring him.
- The cheat does not give power; it makes other people's cultivation rules leak.
- The sect did not abandon him; it has been using him as a lock.
- Every breakthrough steals a word, memory, shadow, name, bone, debt, or fate from someone else.
- The villain wants order, purity, silence, symmetry, repayment, or ritual more than victory.
