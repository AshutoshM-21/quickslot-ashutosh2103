function parseSports(value) {
  if (!value) {
    return [];
  }

  if (Array.isArray(value)) {
    return value.map((sport) => String(sport).trim()).filter(Boolean);
  }

  return String(value)
    .split(",")
    .map((sport) => sport.trim())
    .filter(Boolean);
}

function formatVenueRow(row) {
  const sports = parseSports(row.sports || row.sport);

  return {
    id: row.id,
    name: row.name,
    description: row.description ?? null,
    location: row.location ?? null,
    sports,
  };
}

module.exports = {
  parseSports,
  formatVenueRow,
};
