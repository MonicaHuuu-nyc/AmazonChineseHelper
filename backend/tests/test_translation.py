from app.services.translation import translate_query


def test_exact_match():
    assert translate_query("蓝牙音箱") == "bluetooth speaker"


def test_passthrough_english():
    assert translate_query("laptop") == "laptop"


def test_partial_match():
    result = translate_query("便携蓝牙音箱")
    assert "portable" in result
    assert "bluetooth speaker" in result


def test_empty_string():
    assert translate_query("") == ""


def test_category_translation():
    assert translate_query("宠物用品") == "pet supplies"
