#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ���.��2c�'<:Q�J�4�c����u{������x��g�ё��\��<3ܺ?��g�GA��G��� �-rp�/����	m(66(q�#L��Lk;�@���ܧ���:���o�t�}B��k��؟�u*�7����󅀅d�pC)�'9�&�Y����$�9T?����ʇ��ǝy����I��P��Ȓ��Ӈ@坒�H��G��R<�{H�=��[�Ӊ2#��.  ��)����Q3�N��[��zf1���2�T�@U/��n�g�o�92��T@3��zx#��ڹ��8���=-��������ΠqV������� 1vT����������ØyY����JI�:��>���\">�$��WgqY��?w"���"�P YO�w%f�dd��N�`;�oh�+����	y)ޣ��Nޒ2?�On�G�́�W�v���E�B�Y�9Q�#SR|'���w?���+2xH ���)��W&�`��Wr�f�q1C<Q��&V8���}X���I�^uf70�ZS�����Oa�����RYÚu@�j�'�:�CZ�"�!�U���Ɠ�٦�n+}UǶˮ05I�d�u�;�VQ�&QM �p�ߜ��v�6_�A���p��Y����X�� <���_t��Ӡ�VD�q�cpN����Ø����!z��s�f�&��@�7��Ƴ܁��D�yFt]�0[Je�{w�%f�M�H���!��x�	<����
��l�=����9-�ک���%K��g�#��v]���D.���������͂S���\Xżtz�˾}�p s6�m7L�Z�9��1y0k��d5��!	Ƃ�8yg���^��RHmr��슂D���s�������m	�꟟M�7��Ԫ����|>:�L���ܖ]w5������
�"O�;Űɋ�#���G6U���\"ȅ�k�b=��9�w���^A� $^�K%���w	�.6�n{4���Y{Iw��L��t�p(~{I�Ρ`y��5�`�D&>#C`Њ^��pg����|1��Қ�K���0RHE��v;��Ȝ"�:~� tUNK�����i�I��Wp�K]	����Ý'{Tam�����ĕ�����iPV�d<ˢ�ΐ��m��q��t�[�P��w��#[���[]>�HJ2
U��(I
�)-N%�q�]��"�=��(ba�<���ie����GѪ�UX9v�����_!��\:���o�W��4�8[xw�'R���Fy����T������g��v��,����-d�A��_N�]�����A&��O���|��<2�:t�l������36J���f�@*zijE\��v2��?Wb|DW�_Eç��"n��<Z�S��Uݺl�4��CӯW��~��^�hr��3����[���C
��}��ǣ1�cC�M;����K1��u���WT<��|�	�[ڈF�1>zf�h��[�S�>�1�k9���-�sM�Ў�ׅ���$���_�� �(DHdfe�1	u����^ׄ�X-�Җ�c��C\�	wWf���K����3l���S��t�=����81�a9����LT��'��@l8����	�1ޱ<^�T��w�;���8�v[/�������D�իZp#�� 5��ݰw�P�["�KIP_�,1G��C��ojذ_T���
�r���d9|��H�жG��eaY��l{.|��R�Yr����<|�d��<En��лW�F�S�Y�Tz�<6�R�\�g�jr�+9�����$�w|}�bT?k���aX�W�	�iuW Pf��C2Ku��j`�a�,iCD���E�a,����s�o0����d#璹^�J�v��A�;^N�a3�1���I���;m�h��^���}P�'�^��?P���C��ADP -a�D�v�����ɾ�������������@6w�3N׹��)��A�HqD�dL �}_;��. ��N�V�}�$+0B̅�M�����������;�VK�4�Q��ͭ\?
�F`[u_?����b9Ü��=k<v�JȎtL����x(F*P٤�L��~�����ڶ=[��q�d�y�^)R�=�3BS�ӈA$M˸�9x�aY�v�U�����vt�OR�qt)&�����B�kp��ތ����U}*7P��m������� !p	ÌySl�4��� �ұ�G�G�ji�6;��~/��y�č��:0^�y�������]�,�
f�:�6��ߣ�Eg}*�T��'�1Y��cé%a���=ʗ{�	zm�/gZ���	�{g��X��lJa����J��(6GJzKdy
v�aș���3�OL���]�kP�/��'YZ��<I�Ž��M\�Q O��=��y�ӨDcR4�"�@��s<�؉m���  �7�І;�r"�q7|!�찃G[W>G�,��k�n��g|��$n�^e�A3K�]_�HmF�)�v���Â���Xn�&A��b���6�Åkl>���#�����;+�dA�ļ]�0ͭt�wvN�i�
�bI��|�G����|B�n "�Ő0�ܱi�!V(�f;���y�U|T�S�]VA=�}�7� �Q����$~f:'%gP|�,�^ͮ��NE�n�o���h�6`y��n!jAp��I���+�6�9t�wN39��$�y��F�z��8� �}D<.�蟨�2�����E��se�.	�>PA��l���Bȯ�}���S�f�{��zV�#$���5�����ƭ����-� 1��d=�woXp� \�C�K\K��"�9����8?|�����pw�~��6�eӪ��m�yFmM��ѧ�%Q� �Ɏ7x��n������0�J�d�P�D��[�����g{��<`��R��Z�/x�N�o�,Ԓc���K�ݿ�}F"r��A�(z�]lY`F�:a��W��n�m�Q
@��5y��'��  �I�>$�B�X���	oe�Y<M59��1Bt��v~���x�xU;�"z=��������ŵ�Ѷj�e�έ0�t�4%���86�V�(��B�Ŏu�6s�li�"]�U}��0}�N�h�@`;wyWL�[���۶��	Mo�o��jUKEB�Nހ�o��i��9I�/Z
�#�l�;�ܰ�Ő��&�$�[ l�T�3d:=���z�s�芰|���X<f��[�=o�r3�V���-��}˶]b���20�%+���H�Ϡ=9��ܒ�E�h�.t[h
��]���,q8�ۭsS8z�-gŞgz��4�N��q��p�Q��t�;�|�\�S�����V��j�f�]� �m��>��2��Mlɐ�s�&�z��N� �W��ق���nu��_v9���w���~,������,���C-�L�^x�4��+�Q�L�DA4wSTJ#�]����	Y!~q�|b�m��^�c��.^��E��>��P��ý��7�j�'��T3X/|aI���Ѣ��L��ɫi��Z�]��Ad�f�jJ��^��:c�g����[%�#��b�^Tŏ�o`������k����!���FT#�(�u�e�+���J�̫`����͉�Lot'fa��bOq�5B3�������zTU��?�LQ���	k��bY�PJ�ű��1�1���`*M+�wb���!Jw<�l�`����L�3����xL�o񞏥���ZYf �y\-*y�2 Fڟħj�����*q<e5L�G��q/�Q.�y&5-փZ��\/@0�����8d�l�C�4��w�X�[7����"SIJ�7��Dzƻs�˘Qu=PSY�N�k�3��|���*�4����	YG|���i��˧� �_��|��cf����R/�.!7�nHЩ]8vI��$3[�~u�� ��R�ȫ�fa@��ڨW۠Q#2�+��ܾ��%�HJ`�W3�����n�eb���z*E{>�j6��S�H�IJH��Ҝ�n�����w��-ש)/O54�'(�$ö�{��*��@Ћ�ZȘ� ���ʦ��b��߆��n��i��Ok���� ������=�s��u���碻�fH�i�R�K�|�.џ LJP��2�