const MATCH = """
{
  match {
    id
    date
    type
    local {
      id
    }
    visitor {
      id
    }
  }
}
""";

const SET_MATCH = """
mutation Set(
  \$id: Int!,
  \$date: DateTime,
  \$type: String,
  \$local: Int,
  \$visitor: Int,
)
{
  setMatch(
    id: \$id,
    date: \$date,
    type: \$type,
    local: \$local,
    visitor: \$visitor,
  ) {
    match {
      id
      date
      type
      local {
        id
      }
      visitor {
        id
      }
    }
  }
}
""";

const SAVE_MATCH = """
mutation Save(
  \$date: DateTime!,
  \$type: String!,
  \$local: Int!,
  \$visitor: Int!,
)
{
  saveMatch(
    date: \$date,
    type: \$type,
    local: \$local,
    visitor: \$visitor,
  ) {
    match {
      id
    }
  }
}
""";

const DELETE_MATCH = """
mutation Delete(\$id: Int!)
{
  deleteMatch(id: \$id)
  {
    id
  }
}
""";

const PLAYER = """
{
  player {
    id
    name
    isActive
    photo {
      id
    }
    team {
      id
    }
    position {
      id
    }
  }
}
""";

const SET_PLAYER = """
mutation Set(
  \$id: Int!,
  \$name: String,
  \$photo: Int,
  \$isActive: Boolean,
  \$team: Int,
  \$position: Int,
)
{
  setPlayer(
    id: \$id,
    name: \$name,
    photo: \$photo,
    isActive: \$isActive,
    team: \$team,
    position: \$position,
  ) {
    player {
      id
      name
      isActive
      photo {
        id
      }
      team {
        id
      }
      position {
        id
      }
    }
  }
}
""";

const SAVE_PLAYER = """
mutation Save(
  \$name: String!,
  \$photo: Int!,
  \$isActive: Boolean!,
  \$team: Int!,
  \$position: Int!,
)
{
  savePlayer(
    name: \$name,
    photo: \$photo,
    isActive: \$isActive,
    team: \$team,
    position: \$position,
  ) {
    player {
      id
    }
  }
}
""";

const DELETE_PLAYER = """
mutation Delete(\$id: Int!)
{
  deletePlayer(id: \$id)
  {
    id
  }
}
""";

const PLAYER_POSITION = """
{
  playerPosition {
    id
    name
    details
  }
}
""";

const SET_PLAYER_POSITION = """
mutation Set(
  \$id: Int!,
  \$name: String,
  \$details: GenericScalar,
)
{
  setPlayerPosition(
    id: \$id,
    name: \$name,
    details: \$details,
  ) {
    playerPosition {
      id
      name
      details
    }
  }
}
""";

const SAVE_PLAYER_POSITION = """
mutation Save(
  \$name: String!,
  \$details: GenericScalar!,
)
{
  savePlayerPosition(
    name: \$name,
    details: \$details,
  ) {
    playerPosition {
      id
    }
  }
}
""";

const DELETE_PLAYER_POSITION = """
mutation Delete(\$id: Int!)
{
  deletePlayerPosition(id: \$id)
  {
    id
  }
}
""";

const SCORE = """
{
  score {
    id
    min
    player {
      id
    }
    match {
      id
    }
  }
}
""";

const SET_SCORE = """
mutation Set(
  \$id: Int!,
  \$min: Int,
  \$player: Int,
  \$match: Int,
)
{
  setScore(
    id: \$id,
    min: \$min,
    player: \$player,
    match: \$match,
  ) {
    score {
      id
      min
      player {
        id
      }
      match {
        id
      }
    }
  }
}
""";

const SAVE_SCORE = """
mutation Save(
  \$min: Int!,
  \$player: Int!,
  \$match: Int!,
)
{
  saveScore(
    min: \$min,
    player: \$player,
    match: \$match,
  ) {
    score {
      id
    }
  }
}
""";

const DELETE_SCORE = """
mutation Delete(\$id: Int!)
{
  deleteScore(id: \$id)
  {
    id
  }
}
""";

const TEAM = """
{
  team {
    id
    name
    description
    marketValue
    logo {
      id
    }
    rival {
      id
    }
  }
}
""";

const SET_TEAM = """
mutation Set(
  \$id: Int!,
  \$name: String,
  \$logo: Int,
  \$description: String,
  \$marketValue: Float,
  \$rival: Int,
)
{
  setTeam(
    id: \$id,
    name: \$name,
    logo: \$logo,
    description: \$description,
    marketValue: \$marketValue,
    rival: \$rival,
  ) {
    team {
      id
      name
      description
      marketValue
      logo {
        id
      }
      rival {
        id
      }
    }
  }
}
""";

const SAVE_TEAM = """
mutation Save(
  \$name: String!,
  \$logo: Int!,
  \$description: String!,
  \$marketValue: Float!,
  \$rival: Int,
)
{
  saveTeam(
    name: \$name,
    logo: \$logo,
    description: \$description,
    marketValue: \$marketValue,
    rival: \$rival,
  ) {
    team {
      id
    }
  }
}
""";

const DELETE_TEAM = """
mutation Delete(\$id: Int!)
{
  deleteTeam(id: \$id)
  {
    id
  }
}
""";

const USER = """
{
  user {
    id
    username
    firstName
    lastName
    email
    isActive
    teams {
      id
    }
    profileImage {
      id
    }
  }
}
""";

const SET_USER = """
mutation Set(
  \$id: Int!,
  \$username: String,
  \$firstName: String,
  \$lastName: String,
  \$email: String,
  \$isActive: Boolean,
  \$password: String,
  \$profileImage: Int,
  \$teams: [Int],
)
{
  setUser(
    id: \$id,
    username: \$username,
    firstName: \$firstName,
    lastName: \$lastName,
    email: \$email,
    isActive: \$isActive,
    password: \$password,
    teams: \$teams,
    profileImage: \$profileImage,
  ) {
    user {
      id
      username
      firstName
      lastName
      email
      isActive
      teams {
        id
      }
      profileImage {
        id
      }
    }
  }
}
""";

const SAVE_USER = """
mutation Save(
  \$username: String!,
  \$firstName: String!,
  \$lastName: String!,
  \$email: String!,
  \$isActive: Boolean!,
  \$password: String!,
  \$profileImage: Int!,
  \$teams: [Int],
)
{
  saveUser(
    username: \$username,
    firstName: \$firstName,
    lastName: \$lastName,
    email: \$email,
    isActive: \$isActive,
    password: \$password,
    teams: \$teams,
    profileImage: \$profileImage,
  ) {
    user {
      id
    }
  }
}
""";

const DELETE_USER = """
mutation Delete(\$id: Int!)
{
  deleteUser(id: \$id)
  {
    id
  }
}
""";